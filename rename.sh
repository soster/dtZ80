# Rename all *.txt to *.text
for f in *.asm; do 
    mv -- "$f" "${f%.asm}.z80"
done
