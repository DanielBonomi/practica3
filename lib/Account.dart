
class Account {
  final String number;
  late double _balance;

  double get balance => _balance;

  Account(this.number, {double balance=0}) {
    if (balance<0) {
      throw ArgumentError("Attempted creating an account with negative balance");
    }
    this._balance = balance;
  }

  void deposit(double amount) {
    if (amount <= 0) {
      throw ArgumentError("Account deposit with negative amount");
    }
    _balance+=amount;
  }
  void withdraw(double amount) {
    if (amount <= 0) {
      throw ArgumentError("Account withdraw with negative amount");
    }
    if (_balance<amount) {
      throw StateError("Account withdraw failed due to insufficient balance");
    }
    _balance-=amount;
  }
}