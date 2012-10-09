-------------------------------------------------------------------------------
-- Multi User World
-- Copyright (C) 2001 Jason Clow
-------------------------------------------------------------------------------

function heshe(m)
  if m.gender == "male" then
    return "he"
  elseif m.gender == "female" then
    return "she"
  else
    return "it"
  end
end

function himher(m)
  if m.gender == "male" then
    return "him"
  elseif m.gender == "female" then
    return "her"
  else
    return "it"
  end
end

function hisher(m)
  if m.gender == "male" then
    return "his"
  elseif m.gender == "female" then
    return "her"
  else
    return "its"
  end
end

-- {s-} self
-- {t-} target
--
-- uppercase - capitalize the string
--
-- {-n|N} name
-- {-e|E} he/she
-- {-m|M} him/her
-- {-s|S} his/her

-- social substition
function ssub(string, self, target)
  local x = function(c)
    if strlen(c) ~= 2 then
      return "{"..c.."}"
    else
      local a, b = strsub(c, 1, 1), strsub(c, 2, 2)
      local m
      if a == "s" then
        m = %self
      elseif a == "t" then
        m = %target
      end
      if b == "n" then
        return m.name
      elseif b == "N" then
        return cap(m.name)
      elseif b == "e" then
        return heshe(m)
      elseif b == "E" then
        return cap(heshe(m))
      elseif b == "m" then
        return himher(m)
      elseif b == "M" then
        return cap(himher(m))
      elseif b == "s" then
        return hisher(m)
      elseif b == "S" then
        return cap(hisher(m))
      end
    end
  end
  string, junk = gsub(string, "{(.-)}", x)
  return string
end

function social(self, soc, arg)
  -- check argument
  if not arg or arg == "" then
    -- no target, use [2]+[3]
    if soc[2] then self:output(ssub(soc[2], self, self)) end
    if soc[3] then self.parent:output(ssub(soc[3], self, self), self) end
  else
    -- specified a target, find it
    local mob = self.parent:get_mobile(arg)
    -- check if argument is 'self'
    if arg == "self" then
      mob = self
    end
    -- did we find them?
    if not mob then
      self:output("You don't see them here.")
    else
      -- it's someone else, use [4]+[5]+[6]
      if m ~= self then
        if soc[4] then self:output(ssub(soc[4], self, mob)) end
        if soc[5] then mob:output(ssub(soc[5], self, mob)) end
        if soc[6] then self.parent:output(ssub(soc[6], self, mob), self, mob) end
				-- try social trigger
				mob:trigger("social", self, soc[1])
      -- it's us! use [7]+[8]
      else
        if soc[7] then self:output(ssub(soc[7], self, mob)) end
        if soc[8] then self.parent:output(ssub(soc[8], self, mob), self) end
      end
    end
  end
end

-- [1] command
-- [2] default (to self)
-- [3] default (to sector)
-- [4] target (to self)
-- [5] target (to target)
-- [6] target (so sector)
-- [7] self (to self)
-- [8] self (to sector)

socials =
{
  -- A
  -- B
  {"bow",
   "You bow deeply.",
   "{sN} bows deeply.",
   "You bow before {tn}.",
   "{sN} bows before you.",
   "{sN} bows before {tn}.",
   "You can't bow to yourself...",
   nil},

  {"blink",
   "You blink.",
   "{sN} blinks.",
   "You blink at {tn}.",
   "{sN} blinks at you.",
   "{sN} blinks at {tn}.",
   "You blink.",
   "{sN} blinks."},

  -- C
  {"chuckle",
   "You chuckle.",
   "{sN} chuckles.",
   "You chuckle at {tn}.",
   "{sN} chuckles at you.",
   "{sN} chuckles at {tn}.",
   "You chuckle to yourself.",
   "{sN} chuckles to {sm}self."},

  {"cry",
   "You burst into tears.",
   "{sN} bursts into tears.",
   "You cry on {tn}'s shoulder.",
   "{sN} cries on your shoulder.",
   "{sN} cries on {tn}'s shoulder.",
   "You hold your head in your hands and cry.",
   "{sN} holds {ss} head in {ss} hands and cries."},
  
  {"curse",
   "You curse loudly.",
   "{sN} curses loudly.",
   "You curse at {tn}.",
   "{sN} curses at you.",
   "{sN} curses at {tn}.",
   "You curse yourself.",
   "{sN} curses {sm}self."},

  -- D
  -- E
  {"embrace",
   "Who do you want to embrace?",
   nil,
   "You embrace {tn}.",
   "{sN} embraces you.",
   "{sN} embraces {tn}.",
   "You embrace yourself.",
   "{sN} embraces {sm}self."},

  -- F
  {"frown",
   "You frown.",
   "{sN} frowns.",
   "You frown at {tn}.",
   "{sN} frowns at you.",
   "{sN} frowns at {tn}.",
   "You frown.",
   "{sN} frowns."},

  {"fume",
   "You grit your teeth and fume.",
   "{sN} grits {ss} teeth and fumes.",
   "You glare at {tn}, fuming.",
   "{sN} glares at you, fuming.",
   "{sN} glares at {tn}, fuming.",
   "You grit your teeth and fume.",
   "{sN} grits {ss} teeth and fumes."},

  -- G
  {"gasp",
   "You gasp in surprise.",
   "{sN} gasps in surprise.",
   "You gasp in surprise.",
   "{sN} gasps in surprise.",
   "{sN} gasps in surprise.",
   "You gasp in surprise.",
   "{sN} gasps in surprise."},

  {"giggle",
   "You giggle.",
   "{sN} giggles.",
   "You giggle at {tn}.",
   "{sN} giggles at you.",
   "{sN} giggles at {tn}.",
   "You giggle to yourself.",
   "{sN} giggles to {sm}self."},

  {"glare",
   "Glare at who?",
   nil,
   "You glare at {tn}.",
   "{sN} glares at you.",
   "{sN} glares at {tn}.",
   "You'd need a mirror to glare at yourself...",
   nil},

  {"greet",
   "Who would you like to greet?",
   nil,
   "You greet {tn}.",
   "{sN} greets you.",
   "{sN} greets {tn}",
   "Er... you can't greet yourself...",
   nil},

  {"grin",
   "You grin.",
   "{sN} grins.",
   "You grin at {tn}.",
   "{sN} grins at you.",
   "{sN} grins at {tn}.",
   "You grin at yourself.",
   "{sN} grins at {sm}self."},

  {"groan",
   "You groan.",
   "{sN} groans.",
   "You groan at {tn}.",
   "{sN} groans at you.",
   "{sN} groans at {tn}.",
   "You groan to yourself.",
   "{sN} groans to {sm}self."},

  {"grovel",
   "Grovel before who?",
   nil,
   "You grovel before {tn}.",
   "{sN} grovels before you.",
   "{sN} grovels before {tn}.",
   "Wha...?",
   nil},

  {"growl",
   "You growl - Grrr...",
   "{sN} growls - Grrr...",
   "You growl at {tn} - Grrr...",
   "{sN} growls at you - Grrr...",
   "{sN} growls at {tn} - Grrr...",
   "You growl - Grrr...",
   "{sN} growls - Grrr..."},

  -- H
  {"hug",
   "Who do you want to hug?",
   nil,
   "You hug {tn}.",
   "{sN} hugs you.",
   "{sN} hugs {tn}.",
   "You hug yourself.",
   "{sN} hugs {sm}self."},

  -- I
  -- J
  -- K
  {"kick",
   "Who do you want to kick?",
   nil,
   "You kick {tn}.",
   "{sN} kicks you.",
   "{sN} kicks {tn}.",
   "You kick yourself. Ouch!",
   "{sN} kicks {sm}self."},

  -- L
  {"laugh",
   "You laugh.",
   "{sN} laughs.",
   "You laugh at {tn}.",
   "{sN} laughs at you.",
   "{sN} laughs at {tn}.",
   "You laugh at yourself.",
   "{sN} laughs at {sm}self."},

  -- M
  -- N
  {"nod",
   "You nod.",
   "{sN} nods.",
   "You nod at {tn}.",
   "{sN} nods at you.",
   "{sN} nods at {tn}.",
   "You nod to yourself.",
   "{sN} nods to {sm}self."},

  {"nudge",
   "Nudge who?",
   nil,
   "You nudge {tn}.",
   "{sN} nudges you.",
   "{sN} nudges {tn}.",
   "You nudge yourself...",
   "{sN} nudges {sm}self..."},

  -- O
  -- P
  {"pat",
   "You pat yourself on the head.",
   "{sN} pats {sm}self on the head.",
   "You pat {tn} on the head.",
   "{sN} pats you on the head.",
   "{sN} pats {tn} on the head.",
   "You pat yourself on the head.",
   "{sN} pats {sm}self on the head."},

  {"pet",
   "Pet who?",
   nil,
   "You pet {tn}.",
   "{sN} pets you.",
   "{sN} pets {tn}.",
   "You pet yourself.",
   "{sN} pets {sm}self."},

  {"point",
   "You point.. somewhere...",
   "{sN} points.. somewhere...",
   "You point at {tn}.",
   "{sN} points at you.",
   "{sN} points at {tn}.",
   "You point to yourself.",
   "{sN} points to {sm}self."},

  {"poke",
   "Who do you want to poke?",
   nil,
   "You poke {tn}.",
   "{sN} pokes you.",
   "{sN} pokes {tn}.",
   "You poke yourself.",
   "{sN} pokes {sm}self."},

  {"ponder",
   "You ponder the meaning of it all...",
   "{sN} ponders the meaning of it all...",
   "Um... ok.",
   nil,
   nil,
   "Um... ok.",
   nil},

  {"pout",
   "You pout.",
   "{sN} pouts.",
   "You pout.",
   "{sN} pouts.",
   "{sN} pouts.",
   "You pout.",
   "{sN} pouts."},

  {"punch",
   "Punch who?",
   nil,
   "You punch {tn}.",
   "{sN} punches you.",
   "{sN} punches {tn}.",
   "You punch yourself. Ow!",
   "{sN} punches {sm}self."},

  -- Q
  -- R
  {"roll",
   "You roll your eyes in disgust.",
   "{sN} rolls {ss} eyes in disgust.",
   "You roll your eyes at {tn}.",
   "{sN} rolls {ss} eyes at you.",
   "{sN} rolls {ss} eyes at {tn}.",
   "You roll your eyes in disgust.",
   "{sN} rolls {ss} eyes in disgust."},

  -- S
  {"scream",
   "You scream - Arrgh!",
   "{sN} screams - Arrgh!",
   "You scream at {tn} - Arrgh!",
   "{sN} screams at you - Arrgh!",
   "{sN} screams at {tn} - Arrgh!",
   "You scream - Arrgh!",
   "{sN} screams - Arrgh!"},

  {"shake",
   "You shake your head...",
   "{sN} shakes {ss} head...",
   "You shake your head at {tn}...",
   "{sN} shakes {ss} head at you...",
   "{sN} shakes {ss} head at {tn}...",
   "You shake your head...",
   "{sN} shakes {ss} head..."},

  {"shiver",
   "You shiver - Brrr...",
   "{sN} shivers - Brrr...",
   "You shiver - Brrr...",
   "{sN} shivers - Brrr...",
   "{sN} shivers - Brrr...",
   "You shiver - Brrr...",
   "{sN} shivers - Brrr..."},

  {"shrug",
   "You shrug.",
   "{sN} shrugs.",
   "You shrug.",
   "{sN} shrugs.",
   "{sN} shrugs.",
   "You shrug.",
   "{sN} shrugs."},

  {"sigh",
   "You sigh...",
   "{sN} sighs...",
   "You sigh...",
   "{sN} sighs...",
   "{sN} sighs...",
   "You sighs...",
   "{sN} sighs..."},

  {"slap",
   "Slap who?",
   nil,
   "You slap {tn} in the face!",
   "{sN} slaps you in the face!",
   "{sN} slaps {tn} in the face!",
   "You slap yourself in the face.",
   "{sN} slaps {sm}self in the face."},
  
  {"smile",
   "You smile.",
   "{sN} smiles.",
   "You smile at {tn}.",
   "{sN} smiles at you.",
   "{sN} smiles at {tn}.",
   "You smile to yourself.",
   "{sN} smiles to {sm}self."},

  {"smirk",
   "You smirk.",
   "{sN} smirks.",
   "You smirk at {tn}.",
   "{sN} smirks at you.",
   "{sN} smirks at {tn}.",
   "You smirk.",
   "{sN} smirks."},

  {"snap",
   "You snap your fingers.",
   "{sN} snaps {ss} fingers.",
   "You snap your fingers at {tn}.",
   "{sN} snaps {ss} fingers at you.",
   "{sN} snaps {ss} fingers at {tn}.",
   "You snap your fingers.",
   "{sN} snaps {ss} fingers."},

  {"snarl",
   "You snarl.",
   "{sN} snarls.",
   "You snarl at {tn}.",
   "{sN} snarls at you.",
   "{sN} snarls at {tn}.",
   "You snarl.",
   "{sN} snarls."},

  {"snicker",
   "You snicker.",
   "{sN} snickers.",
   "You snicker at {tn}.",
   "{sN} snickers at you.",
   "{sN} snickers at {tn}.",
   "You snicker.",
   "{sN} snickers."},

  {"snore",
   "You snore - Zzz...",
   "{sN} snores - Zzz...",
   "You snore - Zzz...",
   "{sN} snores - Zzz...",
   "{sN} snores - Zzz...",
   "You snore - Zzz...",
   "{sN} snores - Zzz..."},

  {"spit",
   "You spit on the ground.",
   "{sN} spits on the ground.",
   "You spit at {tn}.",
   "{sN} spits at you.",
   "{sN} spits at {tn}.",
   "You spit on yourself. Ew!",
   "{sN} spits on {sm}self. Ew!"},

  {"stare",
   "You stare at the sky.",
   "{sN} stares into the sky.",
   "You stare at {tn}.",
   "{sN} stares at you.",
   "{sN} stares at {tn}.",
   "You stare at yourself.",
   "{sN} stares at {sm}self."},

  {"sulk",
   "You bow your head and sulk.",
   "{sN} bows {ss} head and sulks.",
   "You bow your head and sulk.",
   "{sN} bows {ss} head and sulks.",
   "{sN} bows {ss} head and sulks.",
   "You bow your head and sulk.",
   "{sN} bows {ss} head and sulks."},

  -- T
  {"taunt",
   "Taunt who?",
   nil,
   "You taunt {tn}.",
   "{sN} taunts you.",
   "{sN} taunts {tn}.",
   "You taunt yourself.",
   nil},

  {"think",
   "You think - Hmmm...",
   "{sN} thinks - Hmmm...",
   "You think - Hmmm...",
   "{sN} thinks - Hmmm...",
   "{sN} thinks - Hmmm...",
   "You think - Hmmm...",
   "{sN} thinks - Hmmm..."},

  -- U
  -- V
  -- W
  {"wave",
   "You wave.",
   "{sN} waves.",
   "You wave to {tn}.",
   "{sN} waves to you.",
   "{sN} waves to {tn}.",
   "You wave.",
   "{sN} waves."},

  {"whine",
   "You whine.",
   "{sN} whines.",
   "You whine.",
   "{sN} whines.",
   "{sN} whines.",
   "You whine.",
   "{sN} whines."},

  {"whistle",
   "You whistle.",
   "{sN} whistles.",
   "You whistle at {tn}.",
   "{sN} whistles at you.",
   "{sN} whistles at {tn}.",
   "You whistle a tune to yourself.",
   "{sN} whistles a tune to {sm}self."},

  {"wink",
   "You wink.",
   "{sN} winks.",
   "You wink at {tn}.",
   "{sN} winks at you.",
   "{sN} winks at {tn}.",
   "You wink.",
   "{sN} winks."},

  -- X
  -- Y
  {"yawn",
   "You yawn.",
   "{sN} yawns.",
   "You yawn.",
   "{sN} yawns.",
   "{sN} yawns.",
   "You yawn.",
   "{sN} yawns."},

  -- Z
}
