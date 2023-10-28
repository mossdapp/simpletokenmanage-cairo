// SPDX-License-Identifier: MIT

use starknet::ContractAddress;


#[starknet::interface]
trait ISimpletokenManage<TContractState> {

    fn simpletoken_allowance(self: @TContractState, asset: ContractAddress, spender: ContractAddress) -> u256;
    fn simpletoken_transfer(ref self: TContractState, asset: ContractAddress, recipient: ContractAddress, amount: u256);
    fn simpletoken_approve(ref self: TContractState, asset: ContractAddress, spender: ContractAddress, amount: u256) -> bool;
    fn simpletoken_approve_for_all(ref self: TContractState, spender: ContractAddress, approved: bool) -> bool;
    fn simpletoken_is_approve_for_all(self: @TContractState, spender: ContractAddress) -> bool;

}
