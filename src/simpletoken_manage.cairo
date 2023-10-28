// SPDX-License-Identifier: MIT

#[starknet::contract]
mod SimpletokenManage {
    //use integer::BoundedInt;
    use simpletoken_manage::interface::ISimpletokenManage;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use zeroable::Zeroable;
    use array::ArrayTrait;

    #[storage]
    struct Storage {
        _simpletoken_allowances: LegacyMap<(ContractAddress, ContractAddress), u256>,
        _simpletoken_allowances_all: LegacyMap<ContractAddress, bool>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        Approval: Approval,
        ApprovalForAll: ApprovalForAll
    }

    #[derive(Drop, starknet::Event)]
    struct Approval {
        asset: ContractAddress,
        spender: ContractAddress,
        value: u256
    }

    #[derive(Drop, starknet::Event)]
    struct ApprovalForAll {
        spender: ContractAddress,
        approved: bool
    }

    #[external(v0)]
    impl SimpletokenManageImpl of ISimpletokenManage<ContractState> {

        fn simpletoken_allowance(self: @ContractState, asset: ContractAddress, spender: ContractAddress) -> u256 {
            self._simpletoken_allowances.read((asset, spender))
        }

        fn simpletoken_transfer(ref self: ContractState, asset: ContractAddress, recipient: ContractAddress, amount: u256) {
            let mut __calldata__ = traits::Default::default();
            serde::Serde::<ContractAddress>::serialize(@recipient, ref __calldata__);
            serde::Serde::<u256>::serialize(@amount, ref __calldata__);
            
            let caller = get_caller_address();
            if (get_contract_address() != caller && self._simpletoken_allowances_all.read(caller) == false ){
                 assert(amount <= self._simpletoken_allowances.read((asset, get_caller_address())), 'SimpletokenManage: insufficient'); 
                 self._approve(asset, caller, self._simpletoken_allowances.read((asset, caller)) - amount);
            }
            
            starknet::call_contract_syscall(asset, selector!("transfer"), array::ArrayTrait::span(@__calldata__),);
        }

        fn simpletoken_approve(ref self: ContractState, asset: ContractAddress, spender: ContractAddress, amount: u256) -> bool {
            assert(get_contract_address() == get_caller_address(), 'SimpletokenManage: only self');
            self._approve(asset, spender, amount);
            true
        }

        fn simpletoken_approve_for_all(ref self: ContractState, spender: ContractAddress, approved: bool) -> bool {
            assert(get_contract_address() == get_caller_address(), 'SimpletokenManage: only self');
            self._simpletoken_approve_for_all(spender, approved);
            true
        }

        fn simpletoken_is_approve_for_all(self: @ContractState, spender: ContractAddress) -> bool {
            self._simpletoken_allowances_all.read(spender)
        }
    }


    #[generate_trait]
    impl InternalImpl of InternalTrait {


        fn _approve(
            ref self: ContractState, asset: ContractAddress, spender: ContractAddress, amount: u256
        ) {
            assert(!asset.is_zero(), 'SimpletokenManage: asset is 0');
            assert(!spender.is_zero(), 'SimpletokenManage: approve to 0');
            self._simpletoken_allowances.write((asset, spender), amount);
            self.emit(Approval { asset, spender, value: amount });
        }

        fn  _simpletoken_approve_for_all(ref self: ContractState, spender: ContractAddress, approved: bool) {
            assert(!spender.is_zero(), 'SimpletokenManage: approve to 0');
            self._simpletoken_allowances_all.write(spender, approved);
            self.emit(ApprovalForAll { spender, approved });
        }

    }

}
