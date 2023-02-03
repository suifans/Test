module rpg_game::main {
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    // use sui::address;
    use sui::tx_context::{Self, TxContext};
    // use rpg_game::utils::{check_id, create_address};
    // use rpg_game::map;

    /// An immutable object that contains information about the
    /// game admin. Created only once in the module initializer,
    /// hence it cannot be recreated or falsified.
    struct GameInfo has key {
        id: UID,
        admin: address
    }

    /// Capability conveying the authority to create boars and potions
    struct GameAdmin has key {
        id: UID,
        /// ID of the game where current user is an admin
        game_id: ID,
    }

    /// On module publish, sender creates a new game. But once it is published,
    /// anyone create a new game with a `new_game` function.
    fun init(ctx: &mut TxContext) {
        create(ctx);
    }

    /// Create a new game. Separated to bypass public entry vs init requirements.
    fun create(ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let id = object::new(ctx);
        let game_id = object::uid_to_inner(&id);

        transfer::freeze_object(GameInfo {
            id,
            admin: sender,
        });

        transfer::transfer(
            GameAdmin {
                game_id,
                id: object::new(ctx),
            },
            sender
        )
    }

    // / Admin can create a boar with the given attributes for `recipient`
    // public entry fun send_boar(
    //     game: &GameInfo,
    //     admin: &mut GameAdmin,
    //     hp: u64,
    //     strength: u64,
    //     map_name:vector<u8>,
    //     ctx: &mut TxContext
    // ) {
    //     check_id(game, admin.game_id);
    //     // send boars to the designated player
    //     let map_address = create_address(map_name);
    //     // transfer::transfer(
    //     //     Boar { id: object::new(ctx), hp, strength, game_id: id(game) },
    //     //     map_address
    //     // )
    // }
}