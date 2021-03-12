with open ("Hack_bin.txt") as f:
    ox = f.read()

str = "{ "

for i in range (len (ox) // 2):
    str += "(unsigned char) 0x" + ox[2 * i : 2 * i + 2].upper() + ", "

str += "}"

with open ("Char_files.txt", "w") as f:
    f.write (str)
