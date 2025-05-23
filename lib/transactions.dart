 import 'Account.dart';

abstract class Transaction{
  String id;
  double amount;
  static int idCt = 0;
  Transaction(this.amount) : id = (idCt++).toString() {
    if (amount<=0) {
      throw ArgumentError("Transaction created with non-positive amount");
    }
  }

  void apply(Account account);
}

class TransferTransaction extends Transaction {
  Account from;

  TransferTransaction(super.amount, this.from);

  @override
  void apply(Account account) {
    if (identical(account, from)) {
      throw ArgumentError("Transfer Transaction can't have the same account as source and target");
    }
    if (from.balance<amount) {
      throw StateError('Transfer Transaction called on Account without enough money');
    }
    from.withdraw(amount);
    account.deposit(amount);
  }
}

class DepositTransaction extends Transaction {
  DepositTransaction(super.amount);

  @override
  void apply(Account account) {
    account.deposit(amount);
  }
}

class WithdrawalTransaction extends Transaction {
  WithdrawalTransaction(super.amount);
  @override
  void apply(Account account) {
    if (account.balance<amount) {
      throw StateError('Withdrawn attempted with insufficient balance');
    }
    account.withdraw(amount);
  }
}
