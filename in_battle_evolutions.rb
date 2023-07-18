class Pokemon
  def check_in_battle_evolution
    return if @personalID != $Trainer.publicID || @check_evolution_flag
    return if speciesData.evolutions.empty?

    speciesData.evolutions.each do |evo|
      next if evo.level.nil? || level < evo.level
      next if evo.method != :level || evo.parameter != level

      new_species = pbCheckEvolutionEx(self, evo)
      next if new_species <= 0

      @check_evolution_flag = true
      pbChangePokemon(self, new_species)
      break
    end
  end
end

# Hook into the core battle script to check for in-battle evolutions.
class PokeBattle_Battle
  alias old_pbSwitchIn_old pbSwitchIn

  def pbSwitchIn(*args)
    old_pbSwitchIn_old(*args)
    @battlers[@battlers.length - 1].check_in_battle_evolution
  end
end






