import banco
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

fn account(id: Int, balance: Int) -> banco.Account {
  banco.Account(id: id, owner: "Test", balance: balance)
}

pub fn deposit_increases_balance_test() {
  let actual = banco.deposit(account(1, 1000), 500)
  let expected = Ok(banco.Account(id: 1, owner: "Test", balance: 1500))

  assert actual == expected
}

pub fn deposit_rejects_invalid_amount_test() {
  assert banco.deposit(account(1, 1000), 0) == Error(banco.InvalidAmount)
  assert banco.deposit(account(1, 1000), -100) == Error(banco.InvalidAmount)
}

pub fn withdraw_decreases_balance_test() {
  let actual = banco.withdraw(account(1, 1000), 300)
  let expected = Ok(banco.Account(id: 1, owner: "Test", balance: 700))

  assert actual == expected
}

pub fn withdraw_rejects_invalid_amount_test() {
  assert banco.withdraw(account(1, 1000), 0) == Error(banco.InvalidAmount)
  assert banco.withdraw(account(1, 1000), -100) == Error(banco.InvalidAmount)
}

pub fn withdraw_rejects_insufficient_funds_test() {
  assert banco.withdraw(account(1, 1000), 1001)
    == Error(banco.InsufficientFunds)
}

pub fn transfer_moves_money_test() {
  let from = account(1, 1000)
  let to = account(2, 500)
  let actual = banco.transfer(from, to, 300)
  let expected =
    Ok(#(banco.Account(..from, balance: 700), banco.Account(..to, balance: 800)))

  assert actual == expected
}

pub fn transfer_rejects_same_account_test() {
  let from = account(1, 1000)
  let to = banco.Account(id: 1, owner: "Another owner", balance: 500)

  assert banco.transfer(from, to, 300) == Error(banco.SameAccount)
}
