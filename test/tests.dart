

import 'dart:math';

import 'package:practica3/transactions.dart';
import 'package:test/test.dart';
import 'package:practica3/Account.dart';
import 'package:practica3/BankService.dart';

void main() {
  group("Grupo Account",() {

    String ac1Name = "412312";
    Account ac1 = Account(ac1Name);
    test("El balance inicial de una cuenta debe ser cero", () {
      expect(ac1.balance,0);
    });
    test("No se permite depositar cantidades negativas o cero", () {
      expect(() => ac1.deposit(-Random().nextDouble()*5-0.1), throwsArgumentError);
      expect(() => ac1.deposit(0), throwsArgumentError);
    });
    test("No se permite retirar cantidades negativas o cero", () {
      expect(() => ac1.withdraw(-Random().nextDouble()*5+0.1), throwsArgumentError);
      expect(() => ac1.withdraw(0), throwsArgumentError);
    });
  });

  group("Grupo Transaction",() {
    Account a = Account("31231");
    double rndDouble = Random().nextDouble() * 15;

    test('Deposit Transaction aumenta el saldo', () {
      Transaction t = DepositTransaction(rndDouble);
      t.apply(a);
      expect(a.balance,rndDouble);
      t.apply(a);
      expect(a.balance, 2*rndDouble);
    });


    test('Withdraw lanza StateError', () {
      Transaction t = WithdrawalTransaction(10);
      Account b = Account("9091", balance: 5);

      expect(() => t.apply(b), throwsStateError);
    });

    test('TransferTransaction mueve fondos de forma correcta', () {
      Account a1 = Account("123", balance: 10);
      Account a2 = Account("456", balance: 14.2);

      Transaction t = TransferTransaction(8, a1);
      t.apply(a2);
      expect(a2.balance,22.2);
      expect(a1.balance, 2);
    });
  });

  group("Grupo BankService",() {
    BankService bank = BankService();
    test('Lista cuenta inicial vacia', () {
      expect(bank.accounts.length, 0);
    });


    double rnd = Random().nextDouble()*10+0.1;
    double rnd2 = Random().nextDouble()*10+0.1;

    test('Deposit aumenta el saldo', () {
      String ac1Name = "123";
      bank.createAccount(ac1Name);
      bank.deposit(ac1Name, rnd);
      expect(bank.getBalance("123"),rnd);
      bank.deposit(ac1Name, rnd2);
      expect(bank.getBalance(ac1Name),greaterThan(rnd));
    });

    test("withdraw lanza StateError cuando el saldo insuficiente",() {
      bank.createAccount("321");
      bank.deposit("321",rnd);
      expect(() => bank.withdrawal("321", rnd2+15),throwsStateError);
    });

    test("transfer mueve fondos correctamente", () {
      String from = "981";
      String to = "003";
      bank.createAccount(from);
      bank.createAccount(to);
      bank.deposit(from, rnd);
      bank.deposit(to, rnd2);
      bank.transfer(from, to, rnd);
      expect(bank.getBalance(from),0);
      expect(bank.getBalance(to),rnd+rnd2);
    });

    test("transfer lanza StateError cuando los fondos son insuficientes", () {
      String from = "0013";
      String to = "731";
      bank.createAccount(from);
      bank.createAccount(to);
      bank.deposit(from, rnd);
      bank.deposit(to, rnd2);
      expect(() => bank.transfer(from, to, rnd+10), throwsStateError);
    });

    test("txId genera identificadores unicos", () {
      List<Transaction> transactions = [];
      Account a = Account("15341231",balance: 10);
      for (int i=0; i<300; i++) {
        transactions.add(WithdrawalTransaction(5));
        transactions.add(DepositTransaction(7));
        transactions.add(TransferTransaction(10, a));
      }
      Set<String> set = Set<String>(); // en un Set la operacion sera' mas facil
      for (int i=0;i<transactions.length;i++) {
        // set.add returns false if the element is already in the set
        expect(set.add(transactions[i].id),true);
      }
    });


  });

  group("EXTRA TESTS SOBRE Service", ()
  {
    BankService bank = BankService();
    String ac1Name = "543";
    Account ac1 = bank.createAccount(ac1Name);
    test('Balance inicial cero - Bank', () {
      expect(ac1.balance, 0);
    });
    test('No depositos <=0 - Bank', () {
      expect(() => bank.deposit(ac1Name, -10), throwsArgumentError);
      expect(() => bank.deposit(ac1Name, 0), throwsArgumentError);
    });
    test('No retiro <=0 - Bank', () {
      expect(() => bank.withdrawal(ac1Name, -10), throwsArgumentError);
      expect(() => bank.withdrawal(ac1Name, 0), throwsArgumentError);
    });
  });
}