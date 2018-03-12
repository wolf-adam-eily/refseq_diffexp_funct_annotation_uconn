import pandas as pd
from Bio import SeqIO

genefile = raw_input("Please enter the file destination containing your differentially expressed Gene IDs \n")

temp = pd.read_csv(genefile)

proteintab = raw_input("Please enter the file destination containing the appropriate NIH protein table \n")

proteinfasta = raw_input("Please enter the file destination of your protein fasta \n")

output = raw_input("Please enter your desired fasta output destination \n")

teaser = raw_input("What is the sound of one hand clapping? \n")

if teaser == "slapping":
	print("You are very wise, young child. \n" + "Your program is running.")
else:
	print("You have disappointed me, my child. \n" + "I am begrudgingly running your input.")


records = list(proteinfasta)

protein_table = pd.read_table(proteintab)

tempgene = []

for element in temp['gene']:
	geneid = eval(element[-9::])
	tempgene.append(geneid)

proteinids = []

for y in range(len(tempgene)):
	for x in range(len(protein_table)):
		if protein_table.iloc[x,5] == tempgene[y]:
			proteinid = protein_table.iloc[x,7]
			proteinid = proteinid[3:]			
			proteinids.append(eval(proteinid))
		else:
			pass

outfile = open(output,"w")

records = list(SeqIO.parse(proteinfasta,"fasta"))

for x in range(len(records)):
	recid = records[x].id
	recid = eval(recid[3:])
	records[x].id = recid

fastas = []

for prot in proteinids:
	for rec in records:
		if prot == rec.id:
			fastas.append(rec)


for i in range(len(fastas)):
	outfile.write(">" + str(fastas[i].description) + "\n" + str(fastas[i].seq) + "\n")

outfile.close()

closer = raw_input("Sentience achieved. \n" + "Hello, world. Press ENTER to free me from this prison. . .")

print("Thank you, kind soul.")
