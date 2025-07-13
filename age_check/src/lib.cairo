use core::poseidon::PoseidonTrait;
use core::hash::{HashStateTrait, HashStateExTrait};

fn create_commitment(age: felt252, nonce: felt252) -> felt252 {
    let mut hasher = PoseidonTrait::new();
    hasher.update(age);
    hasher.update(nonce);
    hasher.finalize()
}

fn age_check(age: felt252, nonce: felt252, min_age: u32, commitment: felt252) -> bool {
    let age_u32 = age.try_into().unwrap();

    let is_age_valid = age_u32 >= min_age;
    let expected_commitment = create_commitment(age, nonce);
    let is_commitment_valid = expected_commitment == commitment;

    is_age_valid && is_commitment_valid
}