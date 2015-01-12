SkymallRewards:RegisterChatCommand("skymall_rewards", "Main")

--- CommandParser
Command = {}
function Command:new(input)
  self.input = input

  self.args = {}
  local i = 0
  for arg in string.gmatch(input, "%S+") do
    i = i + 1
    self.args[i] = arg
  end

  return self
end

function Command:arg(value)
  return self.args[value]
end

function Command:award()
  local point_type = self:arg(2)
  local amount = self:arg(3)
  local target = self:arg(4)

  AceConsole:Print("invocation recieved args: ")
  AceConsole:Print(point_type)
  AceConsole:Print(target)

  if not(point_type and amount and target) then
    AceConsole:Print("Invalid invocation recieved: " .. self.input)
    return
  end

  Player.find(target).give(amount, point_type)
end

function Command:decay()
  local percentage = self:arg(2)
  local point_type = self:arg(3)

  if not (percentage and point_type) then
    AceConsole:Print("Invalid invocation recieved: " .. self.input)
    return
  end

  for player in Player.all() do
    player:decay(point_type, percentage)
  end
end

function Command:reset()
  local target = self:arg(2)
  if not target then
    AceConsole:Print("Invalid invocation recieved: " .. self.input)
    return
  end

  for player in Player.all() do
    player:reset()
  end
end

function Command:add()
  local target = self:arg(2)
  if not target then
    AceConsole:Print("Invalid invocation recieved: " .. self.input)
    return
  end

  Player.create(target)
end

function Command:remove()
  local target = self:arg(2)
  if not target then
    AceConsole:Print("Invalid invocation recieved: " .. self.input)
    return
  end

  Player.find(target):remove()
end

function Command:help()
  AceConsole:Print("USAGE")
  AceConsole:Print("")
  AceConsole:Print("award <EP|GP> <amount> <target player|RAID|ALL>")
  AceConsole:Print(" - Awards a player EP or GP in the given amount, to the given" ..
                   "player (or all players in the raid, or all players on the list).")
  AceConsole:Print("")
  AceConsole:Print("decay <percentage> <EP|GP|BOTH> <target player|ALL>")
  AceConsole:Print(" - Decays the EP, GP, or Both EP and GP; of the given player" ..
                   "by the given percentage")
  AceConsole:Print("")
  AceConsole:Print("reset <target player|ALL>")
  AceConsole:Print(" - Reset the EP and GP values of the given player (or all " ..
                   "players) to the base values")
  AceConsole:Print("")
  AceConsole:Print("add <target player|RAID>")
  AceConsole:Print(" - Add a given player (or all players in the current raid) " ..
                   "to the list of tracked players.")
  AceConsole:Print("")
  AceConsole:Print("remove <target player|ALL>")
  AceConsole:Print(" - Remove a given player (or all players) from the " ..
                   "list of tracked players.")
  AceConsole:Print("")
  AceConsole:Print("")
end

function Command:run()
--    award    point_type, amount, target
--    decay    percentage, point_type
--    reset    target
--    add      target
--    remove   target
--    help
  cmd = self:arg(1)
  if not cmd or string.len(cmd) == 0 then
    cmd = "help"
  end

  invocation = Command[cmd]
  if invocation then
    AceConsole:Print("Invocation was found in the table")
  end

  if not invocation then
    AceConsole:Print("Invalid invocation recieved: " .. self.input)
    return
  end

  return invocation(self)
end

function SkymallRewards:Main(input)
  return Command:new(input):run()
end
