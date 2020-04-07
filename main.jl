module MainModule

mutable struct Weapon
    damage::Int
    critChance::Int
    stunChance::Int
end

mutable struct Armor
    protection::Float16
    breakChance::Int
end

mutable struct Gladiator
    name::String
    health::Int
    dodgeChance::Int
    weapon::Weapon
    armor::Armor
    armorIsBroke::Bool
    isStunned::Bool
    parryChance::Int
end 

mutable struct Players
    player1::Gladiator
    player2::Gladiator
end

function duel(players::Players)

    function attack(attacker::Gladiator, defender::Gladiator)

        println("$(attacker.name) is attacking $(defender.name).")
        rng = rand(1:100)

        function hit()
            damageDealt = 0

            function crit()::Bool
                return rng <= attacker.weapon.critChance ? true : false

            end

            function armorProtection()
                armor = defender.armor
                damageDealt *= armor.protection
            end

            function armorBreak()
                armor = defender.armor
                
                if(rng <= armor.breakChance)
                    defender.armorIsBroke = true
                    return true
                else
                    return false
                end
            end

            function stun()::Bool
    
                if(rng <= attacker.weapon.stunChance)
                    return true
                end
    
                return false
            end

            critOccured = false
            
            if(!attacker.isStunned)
                damageDealt = attacker.weapon.damage


                if(crit())
                    damageDealt *= 2
                    critOccured = true
                    
                end
                
                if(!defender.armorIsBroke)
                    armorProtection()
                end

                if(stun())
                    defender.isStunned = true
                end


                damageDealt = round(damageDealt)
                defender.health -= damageDealt


                if(critOccured)
                    println("$(attacker.name) SLAPPED $(damageDealt) damage at $(defender.name)!")
                else
                    println("$(attacker.name) dealt $(damageDealt) damage to $(defender.name)!")
                end

                if(!defender.armorIsBroke)
                    if(armorBreak())
                        println("$(defender.name)'s armor broke!")
                    end
                end

                if(defender.isStunned)
                    println("$(defender.name) was stunned!")
                end

                println("$(defender.name) has $(defender.health) health remaining!\n")
            else
                attacker.isStunned = false
                println("$(attacker.name) cannot attack because he is stunned.\n")
            end
        
            
        end


        function dodge()::Bool 
            return rng <= defender.dodgeChance ? true : false
        end

        function parry()::Bool
            if(rng <= defender.parryChance)

                parryDamage = round(defender.weapon.damage / 2)

                attacker.health -= parryDamage

                println("$(defender.name) parried the attack and dealt $parryDamage to $(attacker.name)!")
                println("$(attacker.name) has $(attacker.health) health remaining!\n")

                return true

            end

            return false

            
        end



        if(dodge())
            println("$(defender.name) dodged the attack!\n")
        elseif(parry())

        else
            hit()
        end
    end

    playerDead = false
    turn = 1

    player1Local = deepcopy(players.player1)
    player2Local = deepcopy(players.player2)

    if(rand(1:2) == 1)
        attacker = player1Local
        defender = player2Local
    else
        attacker = player2Local
        defender = player1Local
    end

    
    
    roundCount = 0
    newRound = true
    turnCount = 1

    while !playerDead

        if(newRound)
            roundCount += 1
            println("**Round $roundCount**\n")
            newRound = false
            turnCount = 1
        end

        if(turnCount == 2)
            newRound = true
        else
            turnCount += 1
        end


        attack(attacker, defender)

        if(defender.health > 0 && attacker.health > 0)
            temp = attacker
            attacker = defender
            defender = temp
        else
            playerDead = true
            println("#####Game over!#######################\n\n")
        end
    end
end


rustySword = Weapon(25,15,5)

armor = Armor(0.5,20)

player1 = Gladiator("Player 1",100,10,rustySword,armor,false,false,5)
player2 = Gladiator("Player 2",100,10,rustySword,armor,false,false,5)

numIterations = 1


for i = 1:numIterations
    println("Iteration: $i")


    players = Players(player1, player2)

    duel(players)

    println("Iteration: $i")
    
end

#todo
#add parry, double attack


end
