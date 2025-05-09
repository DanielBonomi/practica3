import 'package:practica3/transactions.dart';

import 'Account.dart';

class BankService {
  Map<String,Account> accounts = {};
  Account createAccount(String number) {
    if (accounts.containsKey(number)) {
      throw StateError('Attempting to create account with a number which is already in use');
    }
    Account a = Account(number);
    accounts[number] = a;
    return a;
  }
  void deposit(String account, double amount) {
    if (! accounts.containsKey(account)) {
      ArgumentError("Deposit attempted in non-existing account");
    }
    Transaction t = DepositTransaction(amount);
    t.apply(accounts[account]!);
  }

  void withdrawal(String account, double amount) {
    if (! accounts.containsKey(account)) {
      ArgumentError("Withdraw attempted in non-existing account");
    }
    Transaction t = WithdrawalTransaction(amount);
    t.apply(accounts[account]!);
  }

  void transfer(String from, String to, double amount) {
    if (! accounts.containsKey(from)) {
      ArgumentError("Transfer attempted from non-existing account");
    }
    if (! accounts.containsKey(to)) {
      ArgumentError("Transfer attempted to non-existing account");
    }
    Transaction t = TransferTransaction(amount, accounts[from]!);
    t.apply(accounts[to]!);
  }

  double getBalance(String account) {
    if (! accounts.containsKey(account)) {
      StateError("getBalance attempted for non-existing account");
    }
    return (accounts[account]!).balance;
  }
}