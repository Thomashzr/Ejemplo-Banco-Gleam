pub type Account {
  Account(id: Int, owner: String, balance: Int)
}

pub type BankError {
  InvalidAmount
}

pub fn deposit(account: Account, amount: Int) -> Result(Account, BankError) {
  case amount > 0 {
    True -> Ok(Account(..account, balance: account.balance + amount))
    False -> Error(InvalidAmount)
  }
}

pub fn main() {
  let account = Account(id: 1, owner: "Thomas", balance: 1000)

  let valid_deposit = deposit(account, 500)

  echo valid_deposit

  let invalid_deposit = deposit(account, -200)

  echo invalid_deposit
}
