function compare_dfs --description 'compare 2 csv files using pandas dfs'
    if test (count $argv) -ne 2
        echo "Usage: compare_dfs <file1.csv> <file2.csv>"
        exit 1
    end

    set -l file1 $argv[1]
    set -l file2 $argv[2]

    if not test -f "$file1"
        echo "Error: file not found: $file1"
        exit 1
    end

    if not test -f "$file2"
        echo "Error: file not found: $file2"
        exit 1
    end

    set -l pycode '
import csv
import sys
from pathlib import Path
from collections import Counter

file1, file2 = sys.argv[1], sys.argv[2]

def read_table(path):
    with open(path, newline="") as fh:
        rows = list(csv.reader(fh))
    if not rows:
        return [], []
    return rows[0], rows[1:]

def short_label(path):
    return Path(path).name

def preview_row(row, max_chars=180):
    text = " | ".join(row)
    if len(text) <= max_chars:
        return text
    return text[: max_chars - 3] + "..."

h1, r1 = read_table(file1)
h2, r2 = read_table(file2)

l1 = short_label(file1)
l2 = short_label(file2)

print(f"- compared files: {file1} vs {file2}")
print(f"- headers equal: {h1 == h2}")
print(f"- {file1} rows: {len(r1)}")
print(f"- {file2} rows: {len(r2)}")

if h1 != h2:
    h1_set, h2_set = set(h1), set(h2)
    only_in_1 = h1_set - h2_set
    only_in_2 = h2_set - h1_set
    print(f"- headers diff only in {l1}: {sorted(only_in_1) if only_in_1 else \'-\'}")
    print(f"- headers diff only in {l2}: {sorted(only_in_2) if only_in_2 else \'-\'}")
    
    # Subset to common headers
    common_headers = h1_set & h2_set
    h1_indices = [i for i, h in enumerate(h1) if h in common_headers]
    h2_indices = [i for i, h in enumerate(h2) if h in common_headers]
    r1 = [[row[i] for i in h1_indices] for row in r1]
    r2 = [[row[i] for i in h2_indices] for row in r2]

t1 = [tuple(row) for row in r1]
t2 = [tuple(row) for row in r2]
c1, c2 = Counter(t1), Counter(t2)
s1, s2 = set(c1), set(c2)

print(f"- unique {file1}: {len(s1)}")
print(f"- unique {file2}: {len(s2)}")
print(f"- only in {file1}: {sum((c1 - c2).values())}")
print(f"- only in {file2}: {sum((c2 - c1).values())}")

print(f"- row order identical: {t1 == t2}")

print(f"- rows only in {l1}: ")
for row, n in list((c1 - c2).items())[:20]:
    print(f"- rows only in {l1}: count={n}; row={preview_row(row)}")

print(f"- rows only in {l2}: ")
for row, n in list((c2 - c1).items())[:20]:
    print(f"- rows only in {l2}: count={n}; row={preview_row(row)}")

for i, (a, b) in enumerate(zip(t1, t2), start=2):
    if a != b:
        print(f"- first mismatch line: {i}")
        print(f"- {l1} row: {preview_row(a)}")
        print(f"- {l2} row: {preview_row(b)}")
        break
else:
    if len(t1) == len(t2):
        print("- order mismatch: none")
    else:
        print(f"- order mismatch: none within shared length ({min(len(t1), len(t2))} rows)")

unique_common = [row for row in s1 & s2 if c1[row] == 1 and c2[row] == 1]
if unique_common:
    pos2 = {row: i for i, row in enumerate(t2)}
    deltas = [pos2[row] - i for i, row in enumerate(t1) if row in pos2 and c1[row] == 1 and c2[row] == 1]
    print(f"- most common position shift: {Counter(deltas).most_common(5)}")
else:
    print("- most common position shift: unavailable (no uniquely mappable rows)")
    '

    python3 -c "$pycode" "$file1" "$file2"
end
