// SPDX-License-Identifier: MIT

use starknet::ContractAddress;


#[starknet::interface]
trait ITokenManage<TContractState> {

    fn token_allowance(self: @TContractState, asset: ContractAddress, spender: ContractAddress) -> u256;
    fn token_transfer(ref self: TContractState, asset: ContractAddress, recipient: ContractAddress, amount: u256);
    fn token_approve(ref self: TContractState, asset: ContractAddress, spender: ContractAddress, amount: u256) -> bool;
    fn token_approve_for_all(ref self: TContractState, spender: ContractAddress, approved: bool) -> bool;
    fn token_is_approve_for_all(self: @TContractState, spender: ContractAddress) -> bool;

}
