import gleam/result

pub type Account {
  Account(id: Int, owner: String, balance: Int)
}

pub type BankError {
  InvalidAmount
  InsufficientFunds
  SameAccount
}

pub fn operations(account: Account) -> Result(Account, BankError) {
  use account <- result.try(deposit(account, 500))
  use account <- result.try(withdraw(account, 300))

  Ok(account)
}

pub fn deposit(account: Account, amount: Int) -> Result(Account, BankError) {
  case amount > 0 {
    True -> Ok(Account(..account, balance: account.balance + amount))
    False -> Error(InvalidAmount)
  }
}

pub fn withdraw(account: Account, amount: Int) -> Result(Account, BankError) {
  case amount {
    amount if amount <= 0 -> Error(InvalidAmount)

    amount if amount > account.balance -> Error(InsufficientFunds)

    amount -> Ok(Account(..account, balance: account.balance - amount))
  }
}

pub fn transfer(
  from: Account,
  to: Account,
  amount: Int,
) -> Result(#(Account, Account), BankError) {
  case from.id == to.id {
    True ->
    Error(SameAccount)

    False -> {

  use updated_from <- result.try(withdraw(from, amount))
  use updated_to <- result.try(deposit(to, amount))

  Ok(#(updated_from, updated_to))
}
  }
}

pub fn main() {
  let account_a = Account(id: 1, owner: "Thomas", balance: 1000)
  let account_b = Account(id:2, owner: "Eric", balance: 500)

  case transfer(account_a, account_b, 300) {
    Ok(#(new_a, new_b)) -> {
      echo new_a
      echo new_b
      Nil
    }

    Error(error) -> {
      echo error
      Nil
    }
  }
}
