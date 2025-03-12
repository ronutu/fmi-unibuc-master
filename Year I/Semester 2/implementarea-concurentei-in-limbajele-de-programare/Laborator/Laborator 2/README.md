Problema: Fie un scenariu in care vrem ca o retea de noduri sa valideze tranzactii si sa le adauge la un blockchain. Consideram ca avem un pool de tranzactii, iar un bloc poate fi adaugat doar daca a selectat, pentru validare, fix N tranzactii. Nodurile adauga blocurile intr-un chain, facand si o simulare a POW (proof of work).

classes:
- Transaction: id (string)
- Block: List <Transaction>, hash, prev hash
- Blockchain: Index, List <Block>
- Node: Blockchain, List <Transaction>

Use BlockingQueue<Transaction> transactionPool = new LinkedBlockingQueue<Transaction>; (thread-safe)
Use Integer.toHexString(Objectshash(transactions, prevHash, index));