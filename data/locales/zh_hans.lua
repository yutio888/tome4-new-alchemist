locale "zh_hans"
------------------------------------------------
-- tome-new-alchemist
------------------------------------------------
------------------------------------------------
section "tome-new-alchemist/data/birth/mage.lua"

t("New Alchemist", "炼金术士（新版）", "birth descriptor name")
-- untranslated text
--[==[
t("Golem", "Golem", "birth facial category")
t("An Alchemist is a manipulator of materials using magic.", "An Alchemist is a manipulator of materials using magic.", "_t")
t("They do not use the forbidden arcane arts practised by the mages of old - such perverters of nature have been shunned or actively hunted down since the Spellblaze.", "They do not use the forbidden arcane arts practised by the mages of old - such perverters of nature have been shunned or actively hunted down since the Spellblaze.", "_t")
t("Alchemists can transmute gems to bring forth elemental effects, turning them into balls of fire, torrents of acid, and other effects.  They can also reinforce armour with magical effects using gems, and channel arcane staffs to produce bolts of energy.", "Alchemists can transmute gems to bring forth elemental effects, turning them into balls of fire, torrents of acid, and other effects.  They can also reinforce armour with magical effects using gems, and channel arcane staffs to produce bolts of energy.", "_t")
t("Though normally physically weak, most alchemists are accompanied by magical golems which they construct and use as bodyguards.  These golems are enslaved to their master's will, and can grow in power as their master advances through the arts.", "Though normally physically weak, most alchemists are accompanied by magical golems which they construct and use as bodyguards.  These golems are enslaved to their master's will, and can grow in power as their master advances through the arts.", "_t")
t("Their most important stats are: Magic and Constitution", "Their most important stats are: Magic and Constitution", "_t")
t("#GOLD#Stat modifiers:", "#GOLD#Stat modifiers:", "_t")
t("#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +3 Constitution", "#LIGHT_BLUE# * +0 Strength, +0 Dexterity, +3 Constitution", "_t")
t("#LIGHT_BLUE# * +5 Magic, +1 Willpower, +0 Cunning", "#LIGHT_BLUE# * +5 Magic, +1 Willpower, +0 Cunning", "_t")
t("#GOLD#Life per level:#LIGHT_BLUE# -1", "#GOLD#Life per level:#LIGHT_BLUE# -1", "_t")
t("Golem becomes a Drolem", "Golem becomes a Drolem", "_t")
--]==]


------------------------------------------------
section "tome-new-alchemist/data/gems.lua"

t("Deals %d%% extra fireburn damage", "造成 %d%% 额外火焰燃烧伤害", "tformat")
t("Heals %d", "获得 %d 治疗", "tformat")
t("Deals %d%% extra shadow flame damage and stuns for 3 turns", "造成额外%d%%暗影火焰伤害并震慑3回合", "tformat")
t("Gain one free move in 2 turns (stacks for 3 times)", "2回合内获得1次免费移动机会（可堆叠至三倍）", "_t")
t("Deals %d%% extra fire damage", "造成额外%d%%火焰伤害", "tformat")
t("Deals %d%% extra darkness damage and stuns for 3 turns", "造成额外%d%%暗影伤害并震慑3回合", "tformat")
t("Deals %d%% extra light damage and blinds for 3 turns", "造成额外%d%%光系伤害并致盲3回合", "tformat")
-- untranslated text
--[==[
t("Lights terrain (power 100)", "Lights terrain (power 100)", "_t")
--]==]


------------------------------------------------
section "tome-new-alchemist/data/talents/spells/alchemy-potion.lua"

t("You can only prepare your potions outside of combat.", "你只能在战斗外准备药剂。", "logPlayer")
t("Alchemy Potion", "炼金药剂", "talent name")
t([[With some advanced preparation, you learn to create and equip one of a number of useful potions (at #YELLOW#level %d#WHITE#):

%s
Preparing a tool sets its talent level and puts it on cooldown.
You cannot change your potions in combat. Potions have limited use and can be restored after combat.
]], [[你知道如何准备炼金药剂（#YELLOW#等级 %d #WHITE#）：

%s
准备药剂会重设它的技能等级。
你不能在战斗中更换药剂。药剂具有有限的使用次数，在战斗外你将自动补充。
]], "tformat")
t("Magical Potion", "魔法药剂", "talent name")
t("Ingredient Recycle", "材料回收", "talent name")
t([[You know how to reuse the remain of your potions.
        After throwing bomb, you have %d%% chance to reproduce a random potion.]], [[你学会了回收利用材料。
        投掷炸弹后，有 %d%% 概率随机制造一瓶药剂。]], "tformat")
-- untranslated text
--[==[
t([[#YELLOW#%s (prepared, level %s)#LAST#:
]], [[#YELLOW#%s (prepared, level %s)#LAST#:
]], "tformat")
t([[#GREY#(see talent description)#LAST#
]], [[#GREY#(see talent description)#LAST#
]], "_t")
t("#GREY#You notice %s has prepared: %s.", "#GREY#You notice %s has prepared: %s.", "logSeen")
t("Elixir Potion", "Elixir Potion", "talent name")
--]==]


------------------------------------------------
section "tome-new-alchemist/data/talents/spells/alchemy-potions.lua"

t("Smoke Bomb", "烟雾炸弹", "talent name")
t("Healing Potion", "治疗药水", "talent name")
t("Fiery Wall", "火焰之墙", "talent name")
t("Dissolving Acid", "溶解之酸", "talent name")
t("Lightning Ball", "闪电之球", "talent name")
t("Breath of the Frost", "冰霜之息", "talent name")
t("Stoned Armour", "岩石护甲", "talent name")
t("Potion of Magic", "纯净魔力", "talent name")
t("Potion of Luck", "幸运药水", "talent name")
t("Super Lucky Day", "幸运小子", "talent name")
t("Potion of Swiftness", "迅捷药水", "talent name")
t("Faster Than Light", "超越光速", "talent name")
t([[%s
        Left charges: %d]], [[%s
        剩余次数: %d]], "tformat")
t("Produce smoke for %d turns.", "制造持续 %d 回合的烟雾。", "tformat")
t("Throw a smoke bomb, blocking everyone's line of sight. The smoke dissipates after %d turns.", "投掷烟雾，阻挡视线，烟雾持续 %d 回合。", "tformat")
t("Heal %d and get rid of poison and diseases.", "治疗 %d ，并解除毒素和疾病。", "tformat")
t([[Heal target for %d life and cure all poisons、diseases and wounds.
        The amount healed will increase with your Spellpower.]], [[治疗目标 %d 生命，并解除全部疾病、毒素和伤口状态。
治疗量受法术强度加成。]], "tformat")
t("fire wall", "火墙", "_t")
t("a summoned, transparent wall of fire", "一堵透明的火焰墙。", "_t")
t("%s conjures %d walls of fire!", "%s 制造出%d堵火焰之墙！", "logSeen")
t("Create a fire wall that burns nearby foe, length %d , dur %d , radius %d , dam %d", "制造火墙灼烧周围敌人，长度 %d ，持续 %d ，灼烧半径 %d ，伤害 %d 。", "tformat")
t([[Create a fiery wall of %d length that lasts for %d turns.
        Fire walls may burn any enemy in %d radius, each wall within range deals %d fire damage.
        Burnt enemy will deal %d%% less damage in 3 turns.
        Fire wall does not block movement.]], [[制造出炽热的火焰墙，长度为 %d ，持续 %d 回合。
火墙将灼烧周围 %d 格内的目标，每块火焰将造成 %d 伤害。
被火焰烧伤的敌人在 3 回合内造成的伤害减少 %d%% 。
火墙不会阻挡移动。]], "tformat")
t("Throw bottle of acid that deals %d damage and removes %d sustain", "投掷酸液，造成 %d 伤害并解除对方的 %d 项维持状态。", "tformat")
t([[Acid erupts all around your target, dealing %0.1f acid damage.
		The acid attack is extremely distracting, and may remove up to %d sustains (depending on the Spell Save of the target).
		The damage and chance to remove effects will increase with your Spellpower.]], [[酸液在目标周围爆发，造成 %0.1f 点酸性伤害。
酸性伤害具有腐蚀性，有一定概率除去至多 %d 个持续效果（需要通过对方的法术豁免）。
受法术强度影响，伤害和几率额外加成。]], "tformat")
t("Throw a ball of lightning, daze and blind all targets in radius %d for %d turns.", "投掷半径 %d 的闪电球，眩晕并致盲目标 %d 回合。", "tformat")
t([[Throw a ball of lightning of radius %d, daze and blind all targets for %d turns.
        If the target resists the daze effect it is instead shocked, which halves stun/daze/pin resistance, for %d turns.
        ]], [[投掷半径 %d 的闪电球，眩晕并致盲目标 %d 回合。
如果目标免疫了眩晕，则会被闪电震撼，减半震慑和定身免疫，持续 %d 回合。
]], "tformat")
t("Create a frost shield reducing non-fire damage by %d for %d turns.", "制造寒冰护盾，减少 %d 非火焰伤害 ，持续 %d 回合。", "tformat")
t([[Create a frost shield in range %d, reducing all incoming damage except fire by %d .
        Frost shield lasts %d turns.
        If you're about to get hit by more than 20%% of your max life, this potion will automatically activate.
        ]],
[[投掷药水，为距离 %d 内的目标制造冰霜护盾，减少 %d 非火焰伤害。
冰霜护盾持续 %d 回合。
如果你即将承受超过 20%% 最大生命的伤害，这个药剂会自动激活。]], "tformat")
t("Increase armor by %d , armor hardiness by %d%%, and decrease defense by %d for 6 turns.", "增加 %d 护甲，%d%% 护甲强度，并减少 %d 闪避，效果持续6回合。", "tformat")
t("Restore %d mana and gain %d spellpower in 6 turns", "恢复 %d 法力并获得 %d 法术强度，持续6回合。", "tformat")
t("Becomes super lucky, gain extra %d luck for 6 turns.", "变得非常幸运，6回合内提高 %d 幸运。", "tformat")
t("Becomes super lucky, have %d%% chance to ignore damage in 6 turns. Chance increases with your luck.", "幸运提升，6回合内 %d%% 无视伤害。几率受幸运加成。", "tformat")
t("Becomes extremely fast, gain %d%% movement speed and %d%% global speed for %d turns.", "速度大幅提升，增加 %d%% 移动速度和 %d%% 整体速度，持续 %d 回合", "tformat")
-- old translated text
t("Greatly enchants armor while lowering defense.", "大幅强化护甲，同时减少闪避。", "tformat")
t("Restore mana and gain massive spellpower.", "恢复法力并获得大量法术强度。", "tformat")
t("Becomes super lucky and may ignore incoming damage.", "变得非常幸运，可以躲闪伤害。", "tformat")
t("Becomes much faster than before.", "大幅增加速度。", "tformat")
t("Throw the smoke bomb.", "投掷烟雾弹。", "tformat")
t("Heal and cure, rid of poison and diseases.", "治疗，并解除毒素和疾病。", "tformat")
t("%s conjures a wall of fire!", "%s 制造出火焰之墙！", "logSeen")
t("Create a fire wall that burns nearby foe", "制造火墙灼烧周围敌人。", "_t")
t("Throw bottle of acid that removes sustain", "投掷酸液，解除对方的维持状态。", "_t")
t("Throw a ball of lightning, daze and blind all targets.", "投掷闪电球，眩晕并致盲目标。", "tformat")
t("Create a frost shield reducing damage and critical hits", "制造寒冰护盾，减少伤害。", "tformat")
t([[Becomes super lucky, have %d%% chance to ignore damage in 6 turns.
        Chance increases with your luck.]], [[幸运提升，6回合内 %d%% 无视伤害。
        几率受幸运加成。]], "tformat")

t("Becomes super lucky, have %d%% chance to ignore damage in 6 turns. Chance increases with your luck.", "幸运提升，6回合内 %d%% 无视伤害。几率受幸运加成。", "tformat")
------------------------------------------------
section "tome-new-alchemist/data/talents/spells/elemental-infusion.lua"

t("Manage Elemental Infusion", "调整元素充能", "talent name")
t("Choose your element", "选择元素", "_t")
t("Manage your elemental infusion. Your current infusion is %s.", "调整元素充能。当前充能为 %s 。", "tformat")
t("You have changed your infusion to %s", "你将充能调整至 %s 。", "logPlayer")
t("Elemental Infusion", "元素充能", "talent name")
t([[When you throw your alchemist bombs, you infuse them with %s.
		In addition, %s damage you do is increased by %d%% .
		You may choose your infusion in following elements: fire, cold, lightning, acid, light, darkness, arcane, physical.]], [[投掷炸弹时，用 %s 能量填充之。
        此外，你造成的 %s 伤害提升 %d%% 。
        你可以选择以下元素：火焰、寒冷、闪电、酸蚀、光明、黑暗、奥术、物理。]], "tformat")
t("fire", "火焰", "_t")
t("Infusion Enchantment", "充能强化", "talent name")
t([[If your alchemist bomb crits, it will have a %d%% chance to disable your foes for %d turns, the inflicted effect changes with your elemental infusion:
        -- Fire: Stun
        -- Cold: Frozen feet
        -- Acid: Disarm
        -- Lightning: Daze
        -- Light: Blind
        -- Darkness: Reduces damage by 30%%
        -- Arcane: Silence
        -- Physical: Slow by 30%%
        This can trigger every %d turns.]], [[你的炼金炸弹暴击时，有 %d%% 触发 %d 回合的控制效果:
        -- 火焰：震慑
        -- 寒冷：冻足
        -- 酸性：缴械
        -- 闪电：眩晕
        -- 光明：致盲
        -- 黑暗：减少 30%% 伤害
        -- 奥术：沉默
        -- 物理：减速 30%%
        该效果每 %d 回合只能触发一次。
        ]], "tformat")
t("Energy Recycle", "能量循环", "talent name")
t([[If you have chosen your elemental infusion, every time you deal damage the same type as your infusion, you have %d%% chance to reduce the remaining cooldown of your bomb by %d turns. Besides, you may lower your targets' defense, reducing saves and defense by %d for 3 turns.
        You must deal more than %d damage to trigger this effect.
        Cooldown reduction can happen once per turn.
        ]], [[当你选择充能后，每次造成相同类型伤害时，有 %d%% 概率减少投掷炸弹的冷却时间 %d 回合。此外，你还可以降低敌人的防御能力，豁免和闪避下降 %d ，持续 3 回合。
        伤害值必须超过 %d 才能触发该效果。
        冷却时间缩短效果每回合最多触发一次。
        ]], "tformat")
t("Body of Element", "元素之躯", "talent name")
t("elemental storm", "元素风暴", "_t")
t([[You body turn into pure element. You gain %d%% resistance and %d%% resistance penetration for the specific element you choose.
        You can activate this talent, to conjure a storm of selected element in radius %d for %d turns, dealing %0.2f %s damage each turn.
        ]], [[你的身体部分转化为纯粹的元素形态。对指定充能元素获得 %d%% 抗性， %d%% 抗性穿透。
        你可以主动开启这个技能，制造一场 %d 格范围的元素风暴，持续 %d 回合，所有敌对生物每回合受到 %0.2f %s 伤害。
        ]], "tformat")
-- untranslated text
--[==[
t("#FF8000#The raging fire around %s calms down and disappears.", "#FF8000#The raging fire around %s calms down and disappears.", "logSeen")
--]==]

-- old translated text
t([[You body turn into pure element.
        You gain %d%% resistance, %d%% resistance penetration for the specific element you choose.
        Every turn, a random elemental bolt will hit up to %d of your foes in radius 6, dealing %0.2f %s damage.
        ]], [[你的身体部分转化为纯粹的元素形态。
        对指定充能元素获得 %d%% 抗性， %d%% 抗性穿透。
        此外，每回合开始时，对6格范围内至多 %d 名随机敌人造成 %0.2f %s 伤害。
        ]], "tformat")

------------------------------------------------
section "tome-new-alchemist/data/talents/spells/explosion-control.lua"

t("Throw Bomb: Beam Mode", "投掷炸弹：射线模式", "talent name")
t("You need to ready gems in your quiver.", "你需要准备宝石。", "logPlayer")
t("Current Damage: %0.2f %s", "当前伤害： %0.2f %s", "tformat")
t([[Imbue your gem with pure mana and activate its power as a wide beam and deals %0.2f %s damage.
        This talent can be activated consecutively without going on cooldown, but making any non-instant action other than activation will put this on cooldown.
        Each successful activation will increase damage of the following beams by %d%%, up to 100%%. The mana cost of this beam will also be increased.
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        %s]], [[向一块宝石内灌输爆炸能量，触发一次宽射线类型的 %0.2f %s 伤害。
该技能可以连续使用而不进入冷却，但任何非瞬间的其他行为会使该技能进入冷却。
每次成功使用，会让后续伤害增加 %d%% ，最多增加 100%% 。法力消耗也会随之增加。
你必须学会炸弹投掷技能才能使用该技能。
使用其他投掷炸弹的技能会让该技能进入4回合冷却。
%s]], "tformat")
t("Throw Bomb: Cone Mode", "投掷炸弹：锥形模式", "talent name")
t([[Throw bomb to target location, then making it explode in a radius %d cone, dealing %0.2f %s damage and knocking them back.
        You can choose the direction of the explosion.
        You must know how to throw bomb to use this talent.
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        ]], [[向指定位置投掷炸弹，并触发 %d 范围锥形爆炸，造成 %0.2f %s 伤害并击退敌方目标。
你可以选择爆炸方向。
你必须学会炸弹投掷技能才能使用该技能。
使用其他投掷炸弹的技能会让该技能进入4回合冷却。
]], "tformat")
t("Throw Bomb: Implosion", "投掷炸弹：聚爆", "talent name")
t([[Throw bomb to target location dealing at most %0.2f %s damage in radius %d.
        The damage decreases with the number of targets inside:
        - 2 : deal %0.2f damage
        - 5 : deal %0.2f damage
        - 10: deal %0.2f damage
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        ]], [[向指定位置投掷炸弹造成 %0.2f %s 伤害，爆炸半径 %d 格。
范围内目标越多，伤害越低：
- 2 : 造成 %0.2f 伤害
- 5 : 造成 %0.2f 伤害
- 10: 造成 %0.2f 伤害
你必须学会炸弹投掷技能才能使用该技能。
使用其他投掷炸弹的技能会让该技能进入4回合冷却。
]], "tformat")
t("Throw Bomb: Chain Blast", "投掷炸弹：连环爆破", "talent name")
t([[Throw bomb to target location dealing %0.2f %s damage in radius %d, then make a chained blast:
        Any foe inside the explosion radius will trigger a similar explosion.
        Each successive explosion deals %d%% less damage.
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        ]], [[向指定位置投掷炸弹造成 %0.2f %s 伤害，爆炸半径 %d 格。随后制造一场连环爆破。
任何在伤害范围内的敌人，将触发一次类似的爆炸效果。
每触发一次爆炸，后续爆炸伤害减少 %d%% 。
你必须学会炸弹投掷技能才能使用该技能。
使用其他投掷炸弹的技能会让该技能进入4回合冷却。
]], "tformat")
-- old translated text
t([[Imbue your gem with pure mana and activate its power as a wide beam and deals %0.2f %s damage.
        Throwing bomb by any means will put this talent on cooldown for 4 turns.
        ]], [[向一块宝石内灌输爆炸能量，触发一次宽射线类型的 %0.2f %s 伤害。 
        你必须学会炸弹投掷技能才能使用该技能。
        使用其他投掷炸弹的技能会让该技能进入4回合冷却。
        ]], "tformat")

------------------------------------------------
section "tome-new-alchemist/data/talents/spells/gem-spell.lua"

t("Gem Blast", "宝石爆破", "talent name")
t("You need to ready gems in your quiver.", "你需要准备宝石。", "logPlayer")
t([[Activate your gem's power and fire a bolt of energy to target, dealing %0.2f %s damage.
        If the bolt hits, it will trigger the special effect of gem, and knock back the target for 2 tiles.
        The damage scales with your gem tier and spellpower, and the damage type changes with your gem.
        ]], [[激活宝石发射能量箭，对目标造成 %0.2f %s 伤害。
        如果攻击命中，则会触发宝石的特殊效果，并击退对方2格。
        伤害受宝石和法术强度加成，伤害类型受宝石影响。
        ]], "tformat")
t("Gem's Radiance", "宝石光辉", "talent name")
t( [[Invoke the power of gem, teleports you to up to %d tiles away, to a targeted location (radius %d) in line of sight.
        Then deals %0.2f %s damage to all hostile targets in that area.
        If this attack hits, it will trigger the special effect of gem.
        The damage scales with your gem tier and spellpower, and the damage type changes with your gem.
        ]], [[激活宝石的能量，传送至 %d 格外（误差范围 %d 格），然后对该范围内所有敌人造成 %0.2f %s伤害。
        如果攻击命中，则会触发宝石的特殊效果。
        伤害受宝石和法术强度加成，伤害类型受宝石影响。
        ]], "tformat")
t("Flickering Gem", "闪烁宝石", "talent name")
t([[Invoke the power of gem, making a flash of light, confuses you and other foes in radius 10 for %d turns.
        Then trigger the beneficial effect of the gem on yourself.]], [[激活宝石，制造一次强烈的闪光，令你和周围所有敌人混乱 %d 回合。
        然后对你触发宝石特殊正面效果。]], "tformat")
t("One with Gem", "宝石协调", "talent name")
t("This has beed disabled for %d turns", "该技能在 %d 回合内不会触发。", "tformat")
t([[When you dealt damage the same type as your gem, you may trigger the special effect of your gem.
        Each trigger drains you %d mana.
        This can happen once per turn.]], [[当你造成和宝石的潜在伤害类型一致的伤害时，你可以触发宝石的特殊效果。
        每次触发会抽取你 %d 法力。
        该技能每回合最多触发一次。
        ]], "tformat")
-- untranslated textt
--[==[
t("%s's teleport fizzles!", "%s's teleport fizzles!", "logSeen")
t("You cannot summon; you are suppressed!", "You cannot summon; you are suppressed!", "logPlayer")
--]==]

-- old translated text
t([[Deals %0.2f %s damage to all targets in radius %d.
        If this attack hits, it will trigger the special effect of gem.
        This talent can be activated even in silence.
        Using this talent will disable One with Gem for 5 turns.
        The damage scales with your gem tier, and the damage type changes with your gem.
        This spell cannot crit.
        ]], [[造成 %0.2f %s 范围伤害，伤害半径 %d 。
        如果攻击命中，则会触发宝石的特殊效果。
        该技能不受沉默影响，但不能暴击。
        使用该技能将暂时取消宝石协调的效果 5 回合。
        伤害和伤害类型受宝石影响。
        ]], "tformat")
t([[When you dealt damage the same type as your gem, you may trigger the special effect of your gem.
        This can happen every %d turns.
        %s]], [[当你造成和宝石的潜在伤害类型一致的伤害时，你可以触发宝石的特殊效果。
        该技能每 %d 回合最多触发一次。
        %s]], "tformat")

------------------------------------------------
section "tome-new-alchemist/data/talents/spells/golem-arcane.lua"
t([[Your golem fires a beam from his eyes, doing %0.2f fire damage, %0.2f cold damage or %0.2f lightning damage.
		The beam will always be the maximun range it can be and will not harm friendly creatures.
		The damage will increase with your golem's Spellpower.
		This talent grants your golem %d Spellpower.]], [[从你的眼睛中发射一束光束，造成 %0.2f 火焰伤害， %0.2f 冰冷伤害或 %0.2f 闪电伤害。
        该射线永远具有最大范围，并不会伤害友方单位。
        伤害受傀儡的法术强度加成。
        此外，傀儡的法术强度增加 %d 。]], "tformat")
t([[Your golem's skin shimmers with eldritch energies.
		Any damage it takes is partly reflected (%d%%) to the attacker.
		The golem still takes full damage.
		Damage returned will increase with your golem's Spellpower.
		This talent grants your golem %d Spellpower.]], [[你的傀儡皮肤闪烁着艾尔德里奇能量。
		所有对其造成的伤害有 %d%% 被反射给攻击者。
		傀儡仍然受到全部伤害。
		伤害反射值受傀儡的法术强度加成。
		此外，傀儡的法术强度增加 %d 。]], "tformat")
t([[Your golem pulls all foes within radius %d toward itself while dealing %0.2f arcane damage.
        This talent grants your golem %d Spellpower.]], [[你的傀儡将 %d 码范围内的敌人牵引至身边，并造成 %0.2f 奥术伤害。
        此外，傀儡的法术强度增加 %d 。]], "tformat")
t([[Turns the golem's skin into molten rock. The heat generated sets ablaze everything inside a radius of 3, doing %0.2f fire damage in 3 turns for %d turns.
		Burning is cumulative; the longer they stay within range, they higher the fire damage they take.
		In addition the golem gains %d%% fire resistance.
		Molten Skin damage will not affect friendly creatures.
		The damage and resistance will increase with your Spellpower.
		This talent grants your golem %d Spellpower.]], [[使傀儡的皮肤变成灼热岩浆，发出的热量可以将 3 码范围内的敌人点燃，在 3 回合内每回合造成 %0.2f 灼烧伤害持续 %d 回合。
		灼烧可叠加，他们在火焰之中持续时间越长受到伤害越高。
		此外傀儡获得 %d%% 火焰抵抗。
		炽热皮肤不能影响傀儡的主人。
		伤害和抵抗受法术强度加成。
		此外，傀儡的法术强度增加 %d 。]], "tformat")


------------------------------------------------
section "tome-new-alchemist/data/talents/spells/golem-energy.lua"

t([[Your golem gains %d maximum life and %d life regeneration.
		]], [[你的傀儡获得 %d 最大生命和 %d 生命回复。
		]], "tformat")
t("Shield", "护盾强化", "talent name")
t([[A protective shield surrounds your golem, absorbing %d damage in %d turns.
        If your golem already has a damage shield, will instead increase its power by same amount.
        The total damage the shield can absorb will increase with your Spellpower and can crit.
        This talent grants your golem %d life regeneration.
		]], [[获得吸收量为 %d 的护盾，持续 %d 回合。
		如果傀儡当前已经存在护盾，则会改为强化该护盾。
		护盾吸收量受法术强度加成，可以暴击。
		此外，傀儡的生命回复增加 %d 。]], "tformat")
t("Power", "能量强化", "talent name")
t([[Your golem gains %d physical、spell and mind power and %d life regeneration.
		]], [[傀儡获得 %d 物理、法术和精神强度，以及 %d 生命回复。]], "tformat")
t("Recharge", "充能强化", "talent name")
t([[Your bombs energize your golem, all talents on cooldown on your golem have %d%% chance to be reduced by 1.
        This talent grants your golem %d life regeneration.
		]], [[炸弹会给傀儡充能，每个冷却中的技能都有 %d%% 概率减少一回合剩余冷却时间。
		此外，傀儡的生命回复增加 %d 。]], "tformat")


------------------------------------------------
section "tome-new-alchemist/data/talents/spells/golem-fighting.lua"

t([[Your golem rushes to the target, dealing %d%% damage and knocking it back 3 tiles, then stun it for %d turns.
		Knockback chance and stun chance increases with your golem's physical power.
		While rushing the golem becomes ethereal, passing harmlessly through creatures on the path to its target.
		This talent grants your golem %d physical power.
		]], [[你的傀儡冲向目标，将其击退3格并造成 %d%% 伤害，随后震慑 %d 回合。
		击退和震慑概率受物理强度加成。
		冲锋时傀儡可以越过中间生物。
		此外，傀儡的物理强度增加 %d 。]], "tformat")
t([[The golem taunts targets in a radius of %d, forcing them to attack it.
        Each taunted target will give your golem a shield of %d strenth for 2 turns, or adding to current damage shield.
        This talent grants your golem %d physical power.
        ]], [[你的傀儡嘲讽 %d 码半径范围的敌人，强制他们攻击傀儡。
        每嘲讽一名目标，傀儡获得 %d 护盾，持续2回合。如果当前已有护盾，则改为强化之。
		此外，傀儡的物理强度增加 %d 。]], "tformat")
t([[Your golem rushes to the target, crushing it into the ground for %d turns and doing %d%% damage.
        Then target will be slowed for %d%% in 3 turns.
		Pinning chance will increase with your golem's physical power.
		This talent grants your golem %d physical power.
		While rushing the golem becomes ethereal, passing harmlessly through creatures on the path to its target.]], [[你的傀儡冲向目标，将其推倒在地持续 %d 回合，造成 %d%% 伤害， 随后目标将被减速 %d%% 3回合。
		定身几率受物理强度加成。
		冲锋时傀儡可以越过中间生物。
		此外，傀儡的物理强度增加 %d 。]], "tformat")
t([[Your golem rushes to the target and creates a shockwave with radius 2, dazing all foes for %d turns and doing %d%% damage.
		Daze chance increases with your golem's physical power.
		This talent grants your golem %d physical power.
		While rushing the golem becomes ethereal, passing harmlessly through creatures on the path to its target.]], [[你的傀儡冲向目标，践踏周围 2 码范围，眩晕所有目标 %d 回合并造成 %d%% 伤害。
		眩晕几率受物理强度加成。
		冲锋时傀儡可以越过中间生物。
		此外，傀儡的物理强度增加 %d 。]], "tformat")


------------------------------------------------
section "tome-new-alchemist/data/talents/spells/new-advanced-golemancy.lua"

t("Supercharge Golem", "超载傀儡", "talent name")
t("Your golem is currently inactive.", "你的傀儡暂时处于未激活状态。", "logPlayer")
t("%s's golem is fully restored!", "%s的傀儡完全恢复了！", "logSeen")
t([[You activate a special mode of your golem, boosting its speed by %d%% for %d turns.
        If your golem is inactive, then it will become resurrected. Then fully restore the hit point of your golem upon activation.]], [[激活傀儡，加速 %d%% ，持续 %d 回合。
        如果傀儡没有激活，则复活之。然后，立刻回满傀儡的血量。]], "tformat")
t("Disruption Rune", "干扰符文", "talent name")
t("Golem's Fury", "傀儡之怒", "talent name")
t("Customize", "定制傀儡", "talent name")
t([[You learn how to modify your golem, granting %d accuracy, %d defense and %d saves.
        Besides, your golem gains new equipment slots (based on raw level):
        - At talent level 2 : Can wear hat
        - At talent level 3 : Can wear belt
        - At talent level 4 : Can wear amulet
        - At talent level 5 : Can wear two rings
        ]], [[你学会如何调整傀儡，增加 %d 命中, %d 闪避和 %d 豁免。
        此外，你的傀儡获得额外装备格（基于原始等级）：
        - 等级 2：能装备帽子
        - 等级 3：能装备腰带
        - 等级 4：能装备项链
        - 等级 5：能装备两个戒指]], "tformat")
t([[You activate the disruptive rune in your golem, foes in radius %d will be disrupted for %d turns, their talents have 50%% chance to fail.
        Learn this talent will also grant your golem %d%% resistance to confusion effects.
        ]], [[你激活傀儡身上的干扰符文，你和傀儡 %d 格范围内的敌人将受到 %d 回合的干扰，技能成功率下降 50%% 。
        此外，傀儡的混乱抗性提升 %d%% 。
        ]], "tformat")
t([[Infuse your golem with #GOLD#ULTIMATE POWER#LAST#!
        In %d turns, your golem gains great fury, automatically dealing %0.2f elemental damage (fire/cold/lightning/acid, selected randomly) to foes in radius 6 at the start of each turn.
        While in fury state, your golem's stats are increased by %d .
        The stat and damage boost scales with your golem's spellpower.
        ]], [[激活傀儡的#GOLD#终极能量#LAST#!
        %d 回合内，傀儡会对周围6格内的敌人造成 %0.2f 随机元素伤害。
        此外，傀儡的属性上升 %d 。
        属性和伤害随傀儡的法术强度增加。
        ]], "tformat")

-- old translated text
t("Golem Portal", "傀儡传送", "talent name")
t([[Teleport to your golem, while your golem teleports to your location. Your foes will be confused, and those that were attacking you will have a %d%% chance to target your golem instead.
        After teleportation, you and your golem gain 50%% evasion for %d turns.]], [[交换你和傀儡的位置，敌人有 %d%% 概率选择傀儡为目标。
        传送后，你和傀儡获得 50%% 闪避， 持续 %d 回合。]], "tformat")
t([[You activate the disruptive rune in your golem, foes in radius %d will be disrupted for %d turns, their talents have 50%% chance to fail.
        ]], [[你激活傀儡身上的干扰符文，你和傀儡 %d 格范围内的敌人将受到 %d 回合的干扰，技能成功率下降 50%% 。
        ]], "tformat")
t([[Infuse your golem with #GOLD#ULTIMATE POWER#LAST#!
        In %d turns, your golem gains great fury, automatically dealing %0.2f elemental damage (fire/cold/lightning/acid, selected randomly) to foes in radius 6 at the start of each turn.
        While in fury state, your golem's stats are increased by %d , and your golem deals %d%% more damage.
        The damage, stat and damage boost scales with your golem's spellpower.
        ]], [[激活傀儡的#GOLD#终极能量#LAST#!
        %d 回合内，傀儡会对周围6格内的敌人造成 %0.2f 随机元素伤害。
        此外，傀儡的属性上升 %d ，且额外增加 %d%% 伤害。
        伤害，属性和伤害加成随傀儡的法术强度增加。
        ]], "tformat")
t([[You activate a special mode of your golem, boosting its speed by %d%% for %d turns.
		While supercharged, your golem is enraged and deals %d%% more damage.
        Damage boost scales with your spellpower.]], [[激活傀儡，加速 %d%%， 持续 %d 回合。
        同时，傀儡造成的伤害增加 %d%% 。
        伤害加成随法术强度增加。]], "tformat")
t([[Infuse your golem with #GOLD#ULTIMATE POWER#LAST#!
        In %d turns, your golem gains great fury, automatically dealing %0.2f elemental damage (fire/cold/lightning/acid, selected randomly) to foes in radius 6 at the start of each turn.
        While in fury state, your golem's stats are increased by %d, and if it is already supercharged, will gain %d%% additional damage boost.
        Also, learn this talent will grant your golem %d spellpower and physical power.
        The stat and damage boost scales with your golem's spellpower.
        ]], [[激活傀儡的#GOLD#终极能量#LAST#!
        %d 回合内，傀儡会对周围6格内的敌人造成 %0.2f 随机元素伤害。
        此外，傀儡的属性上升 %d ，且如果已经处于超载状态，会额外增加 %d%% 伤害。
        学习该技能会增加傀儡 %d 法术和物理强度。
        属性和伤害加成随傀儡的法术强度增加。
        ]], "tformat")

------------------------------------------------
section "tome-new-alchemist/data/talents/spells/new-alchemy-potion.lua"

t("You can only prepare your potions outside of combat.", "你只能在战斗外准备药剂。", "logPlayer")
t("Potion Mastery", "药剂精通", "talent name")
t([[With some advanced preparation, you learn to create and equip %d of a number of useful potions (at #YELLOW#level %d#WHITE#).
You may throw your potion as far as you can throw bomb.
Preparing a potion sets its talent level and puts it on cooldown.
You cannot change your potions in combat. Potions have limited use and can be restored after combat.

%s
]], [[你知道如何准备至多 %d 瓶炼金药剂（#YELLOW#等级 %d #WHITE#）.
你投掷药剂的距离和投掷炸弹一样。
准备药剂会重设它的技能等级。
你不能在战斗中更换药剂。药剂具有有限的使用次数，在战斗外你将自动补充。

%s
]], "tformat")
t("Reproduce", "装填", "talent name")
t("%s got disrupted by the incoming damage, stopped reproducing potions.", "%s 被伤害干扰，无法继续装填药剂。", "logPlayer")
t("%s reproduce all the potions.", "%s 装填药剂完毕。", "logPlayer")
t("Remaining turns: %d .", "剩余回合： %d 。", "tformat")
t([[Enter the focused state of reproducing potions。 Every %d turns, you will recharge all your alchemy potions.
        Reproduing potions need focus, any incoming damage may break this state. Every time you are damaged, you must check your physical/spell save to preverse focus. If you fail to save, your reproduction will reset.
        %s]], [[进入专注地装填状态，每隔 %d 回合，你将重新装载所有药剂。
        制作药剂需要专注，当你受到伤害后，需要使用物理或法术豁免通过判定来维持专注。如果豁免失败，装填工作将从头开始。
        %s]], "tformat")
t("Potion Sprayer", "药剂喷射器", "talent name")
t([[You may spray your potion in cone instead of throw onto a single target.
        Besides, learning this talent will make your potions cost %d%% less turn.
        ]], [[你可以在锥形范围内喷射药剂。
        此外，学习此技能会让喷射药剂消耗的时间减少 %d%% 。
        ]], "tformat")
t("Ingredient Recycle", "材料回收", "talent name")
t("Remaining explosions: %d .", "剩余爆炸数： %d 。", "tformat")
t([[You know how to reuse the remain of your potions.
        Every time you consume a potion, you store %d power (current %d ).
        The stored power last 6 turns, and reduces by 10%% each turn not consumed.
        You may activate this talent to release the power as a heal, and every 100 point you heal (before healing mod), you'll regain a potion.
        The heal can crit.]], [[你知道如何利用药剂的剩余材料。
        每次你使用药剂时，获得 %d 能量（当前 %d ）。
        能量存储 6 回合，每回合损失 10%%。
        你可以激活这个技能，给与自身等量治疗。每治疗 100 点（不计算治疗系数），你可以随机获得一瓶药剂。
        治疗量可以暴击。]], "tformat")
-- untranslated text
--[==[
t([[#YELLOW#%s (prepared, level %s)#LAST#:
]], [[#YELLOW#%s (prepared, level %s)#LAST#:
]], "tformat")
t([[#GREY#(see talent description)#LAST#
]], [[#GREY#(see talent description)#LAST#
]], "_t")
t("#GREY#You notice %s has prepared: %s.", "#GREY#You notice %s has prepared: %s.", "logSeen")
--]==]


------------------------------------------------
section "tome-new-alchemist/data/talents/spells/new-explosive.lua"

t("Throw Bomb", "炸弹投掷", "talent name")
t("You need to ready gems in your quiver.", "你需要准备宝石。", "logPlayer")
t([[Imbue an alchemist gem with an explosive charge of mana and throw it.
		The gem will explode for %0.1f %s damage.
		Each kind of gem will also provide a specific effect.
		The damage will improve with better gems and with your Spellpower.
		Using this talent will put other bomb talent go on cooldown.]], [[向一块宝石内灌输爆炸能量并扔出它。 
宝石将会爆炸并造成 %0.1f 的 %s 伤害。
每个种类的宝石都会提供一个特殊的效果。
伤害受宝石品质和法术强度加成。
使用该技能会让其他炸弹投掷进入冷却。]], "tformat")
t("Alchemist Protection", "炼金保护", "talent name")
t([[Grants protection against external elemental damage (fire, cold, lightning and acid) by %d%%.
		You can activate this talent, to grant yourself extra %d%% elemental resistance for %d turns.
		At talent level 3, the flow of elemental energy will cleanse and block elemental detrimental effects.]],
[[增加对外界元素（火焰、寒冷、闪电和酸性）伤害的抗性 %d%% 。
你可以主动激活这个技能，获得额外 %d%% 元素抗性，持续 %d 回合。
技能等级 3 以后，元素能量将解除你身上的所有元素类负面状态，并在剩余回合内阻挡元素类负面状态。]], "tformat")
t("Explosion Expert", "爆破专家", "talent name")
t([[Your alchemist bombs now affect a radius of %d around them. (This only works for the basic Throwing Bomb talent.)
		Explosion damage may increase by %d%% (if the explosion is not contained) to %d%% if the area of effect is confined.]], [[投掷炼金炸弹的爆炸半径现在增加为 %d 码，只对基础投掷生效。
		增加 %d%% （地形开阔）～ %d%% （地形狭窄）爆炸伤害。]], "tformat")
t("Explosion Shield", "爆炸护盾", "talent name")
t("available", "可用", "_t")
t([[Your mastery of explosive material makes you much more resilient against all kinds of critical hits.
        All direct critical hits (physical, mental, spells) against you have a %d%% lower critical multiplier
        Besides, each time your bomb deals a critical hit, you'll gain a shield of %d for 5 turns, or if you already have a shield, increasing its shield power instead. This effect has a cooldown of 4 turns. (Current: %s)
        The power of the shield can crit.]],
[[你对爆炸材料的试验让你更加能够抵抗伤害。
增加 %d%% 被爆伤害减免。
此外，每次炸弹暴击时，你获得 %d 护盾，持续 5回合。如果你当前存在护盾，那么改为补充当前护盾等量的吸收量。这个效果有 4回合冷却（当前： %s )。
护盾吸收量可以暴击。]], "tformat")
t("%s is energized by the attack, reducing some talent cooldowns!", "%s 被充能，减少了技能冷却时间！", "logSeen")

-- old translated text
t([[Imbue an alchemist gem with an explosive charge of mana and throw it.
		The gem will explode for %0.1f %s damage.
		Each kind of gem will also provide a specific effect.
                The damage will improve with better gems and with your Spellpower.
                Using this talent will put other bomb talent go on cooldown.]], [[向一块宝石内灌输爆炸能量并扔出它。 
宝石将会爆炸并造成 %0.1f 的 %s 伤害。
每个种类的宝石都会提供一个特殊的效果。
伤害受宝石品质和法术强度加成。
使用该技能会让其他炸弹投掷进入冷却。]], "tformat")
t([[Grants protection against external elemental damage (fire, cold, lightning and acid) by %d%%.
                Besides, each time you're hit by elemental damage, you may regain %d mana.]], [[提高对外界元素（火焰、寒冷、闪电和酸性）伤害的抗性 %d%% 。
                此外，每次你受到元素伤害时，你可以恢复 %d 法力。]], "tformat")
t([[Imbue an alchemist gem with an explosive charge of mana and throw it.
		The gem will explode for %0.1f %s damage.
		Each kind of gem will also provide a specific effect.
		The damage will improve with better gems and with your Spellpower.]], [[向一块宝石内灌输爆炸能量并扔出它。 
		宝石将会爆炸并造成 %0.1f 的 %s 伤害。 
		每个种类的宝石都会提供一个特殊的效果。 
		伤害受宝石品质和法术强度加成。]], "tformat")
t("Grants protection against external elemental damage (fire, cold, lightning and acid) by %d%%.", "提高对外界元素（火焰、寒冷、闪电和酸性）伤害的抗性 %d%% 。", "tformat")
t("Chain Blasting", "连环爆破", "talent name")
t([[Your alchemist bombs now have %d%% chance to not go on cooldown.
        Chances increases with your gem tier.]], [[炸弹投掷有 %d%% 概率不进入冷却。
        几率受宝石品质加成。]], "tformat")
t([[Your Throw Bomb talent now have %d%% chance to not go on cooldown.
        Chances increases with your gem tier.]], [[你的炸弹投掷技能有 %d%% 概率不进入冷却。
        几率受宝石品质加成。]], "tformat")
t([[Your Throw Bomb talent now have %d%% chance to not go on cooldown.
        Activating this talent will increase the mana cost of Throw Bomb talent by %d .
        Chances increases with your gem tier and spellpower.]], [[你的炸弹投掷技能有 %d%% 概率不进入冷却。
        激活该技能会使投掷炸弹技能的法力值消耗增加 %d 。
        几率受宝石品质和法术强度加成。]], "tformat")

------------------------------------------------
section "tome-new-alchemist/data/talents/spells/new-golemancy.lua"

t("Master must know the Runic Golem talent", "主人必须学会符文傀儡技能", "_t")
t("Master's Runic Golem talent too low for this gem", "主人的符文傀儡技能等级过低", "_t")
t([[Take care of your golem:
		- If it is destroyed, you will take some time to reconstruct it (this takes 20 turns).
		- If it is alive but hurt, you will be able to repair it for %d . Spellpower, gem and Golem Power talent all influence the healing done.]], [[与你的傀儡进行交互：
		- 如果它被摧毁，你将耗费一些时间重新安装傀儡。
		- 如果它还存活，你可以修整它使其恢复 %d 生命值。法术强度、宝石和强化傀儡技能都会影响治疗量。]], "tformat")
t("Gem Golem", "宝石傀儡", "talent name")
t("Golem's armor is increased by 3 per gem's tier, and resistance is increased by 1 per gem's tier.", "宝石每层级提供3点护甲和1%%全体伤害抗性。", "tformat")
t("Golem Power", "傀儡之力", "talent name")
t("Improves your golem's proficiency with weapons, increasing its attack and damage. Then Improves your golem's armour training, damage resistance, and healing efficiency.", "提高傀儡的武器熟练度，增加其命中和伤害。提高傀儡护甲熟练度、伤害抗性和治疗系数。", "_t")
t([[Improves your golem's proficiency with weapons, increasing its Accuracy by %d, Physical Power by %d and damage by %d%%.
		Then improves your golem's armour training, damage resistance, and healing efficiency.
        Increases all damage resistance by %d%%; increases Armour value by %d, Armour hardiness by %d%%, reduces chance to be critically hit by %d%% when wearing heavy mail or massive plate armour, and increases healing factor by %d%%.
        The golem can always use any kind of armour, including massive armours.]], [[提高傀儡的武器熟练度，增加它 %d 点命中、 %d 物理强度和 %d%% 伤害。
        提高傀儡护甲熟练度、伤害抗性和治疗系数。
		增加 %d%% 所有伤害抗性；增加 %d 点护甲和 %d%% 护甲强度；当装备 1 件锁甲或板甲时，减少 %d%% 被暴击率；增加 %d%% 治疗效果。
		傀儡可以使用所有类型的护甲，包括板甲。]], "tformat")
t("Runic Golem", "符文傀儡", "talent name")
t([[Insert a pair of gems into your golem, providing it with the gem bonuses and changing its melee attack damage type. You may remove the gems and insert different ones; this does not destroy the gems you remove.
        Gem level usable: %d
        Gem changing is done in the golem's inventory.
        Each gem will proivide extra armour and all damage resistance which increases with tier.
        Increases your golem's life, mana and stamina regeneration rates by %0.2f.
        At level 1, 3 and 5, the golem also gains a new rune slot.
        Even without this talent, Golems start with three rune slots.]], [[在傀儡身上镶嵌 2 颗宝石，它可以得到宝石加成并改变近战攻击类型。你可以移除并镶嵌不同种类的宝石，移除行为不会破坏宝石。 
		可用宝石等级： %d
        宝石会在傀儡的物品栏中改变成功。
        宝石将根据等级提供额外的护甲和伤害抗性。
        增加傀儡 %0.2f 生命、法力和耐力回复。 
		在等级 1 、 3 、 5 时，傀儡会增加 1 个新的符文孔。 
		即使没有此天赋，傀儡默认也有 3 个符文孔。]], "tformat")
t("Double Heal", "双重治疗", "talent name")
t([[You invoke the power of your gem, healing you and your golem for %d.
        If your golem is dead, it will be resurrected at 50%% life.
        If your golem is active, it will gain a shield which can absorb %d damage for 5 turns.]], [[激活宝石的能量，治疗你和傀儡 %d 生命。
        如果傀儡已经死亡，则以 50%% 血量复活之。
        否则，傀儡获得 %d 吸收量的护盾，持续5回合。]], "tformat")
t("Golem Portal", "傀儡传送", "talent name")
t("Your golem is currently inactive.", "你的傀儡暂时处于未激活状态。", "logPlayer")
t([[Teleport to your golem, while your golem teleports to your location. Your foes will be confused, and those that were attacking you will have a %d%% chance to target your golem instead.
        After teleportation, you and your golem gain 50%% evasion for %d turns.
        At talent level 4, Golem Portal takes no time to cast.
        At talent level 6, when your auto-exploration is stopped by hostile creatures, you'll immediately cast Golem Portal.
        ]], [[交换你和傀儡的位置，敌人有 %d%% 概率选择傀儡为目标。
        传送后，你和傀儡获得 50%% 闪避，持续 %d 回合。
        技能等级 4 以后，傀儡传送技能不再消耗时间。
        技能等级 6 以后，当你的自动探索被敌对生物打断时，你会立刻使用傀儡传送技能。]], "tformat")
-- new text
--[==[
t("Master's Customize talent too low.", "Master's Customize talent too low.", "_t")
--]==]

-- untranslated text
--[==[
t("Golem has no master", "Golem has no master", "_t")
t("impossible to use this gem", "impossible to use this gem", "_t")
t("Your golem is out of sight; you cannot establish direct control.", "Your golem is out of sight; you cannot establish direct control.", "logPlayer")
t("drolem", "drolem", "_t")
t("Interact with the Golem", "Interact with the Golem", "talent name")
t([[Interact with your golem to check its inventory, talents, ...
		Note: You can also do that while taking direct control of the golem.]], [[Interact with your golem to check its inventory, talents, ...
		Note: You can also do that while taking direct control of the golem.]], "tformat")
t("Refit Golem", "Refit Golem", "talent name")
t("Golem", "Golem", "_t")
t("%s (servant of %s)", "%s (servant of %s)", "tformat")
t("Not enough space to refit!", "Not enough space to refit!", "logPlayer")
t("refitting", "refitting", "_t")
t("refitted", "refitted", "_t")
t("You have been interrupted!", "You have been interrupted!", "logPlayer")
t("You need to ready gems in your quiver to heal your golem.", "You need to ready gems in your quiver to heal your golem.", "logPlayer")
t("Not enough space to resurrect!", "Not enough space to resurrect!", "logPlayer")
t("#Target# focuses on #Source#.", "#Target# focuses on #Source#.", "logCombat")
--]==]

-- old translated text
t("Dynamic Recharge", "动态充能", "talent name")
t([[Your bombs energize your golem.
		All talents on cooldown on your golem have %d%% chance to be reduced by %d.]], [[你的炸弹会给傀儡充能。
		你的傀儡的所有冷却中技能有 %d%% 概率减少 %d 回合冷却时间。]], "tformat")
t([[You invoke the power of your gem, healing you and your golem for %d.
		If your golem is dead, it will be resurrected at 50%% life.
        If your golem is below 50%% life, it will gain a shield which can absorb %d damage for 5 turns.]], [[激活宝石的能量，治疗你和傀儡 %d 生命。
        如果傀儡已经死亡，则以 50%% 血量复活之。
        如果傀儡血量少于 50%% ，则额外获得 %d 吸收量的护盾，持续5回合。]], "tformat")
t("Golem's armor is increased by 6 per gem's tier, and resistance is increased by 3 per gem's tier.", "宝石每层级提供6点护甲和3%%全体伤害抗性。", "tformat")

------------------------------------------------
section "tome-new-alchemist/data/talents/spells/spells.lua"

t("elemental alchemy", "元素炼金", "_t")
t("Alchemical spells designed to wage war.", "为战争设计的炼金法术。", "_t")
t("gem spell", "宝石法术", "_t")
t("invoke your gem power.", "激活宝石的能量。", "_t")
t("alchemy potions", "炼金药剂", "_t")
t("prepare some alchemy potions.", "准备炼金药剂。", "_t")
t("some useful alchemy potions.", "有用的炼金药剂。", "_t")
t("explostion-control", "爆炸控制", "_t")
t("Control your alchemist bomb.", "控制炼金炸弹。", "_t")

t("energy", "能量", "_t")
t("Golem energy capacity.", "傀儡的能量系能力。", "_t")
t("arcane", "奥术", "_t")
-- new text
--[==[
t("golem", "golem", "talent category")
t("fighting", "fighting", "_t")
t("Golem melee capacity.", "Golem melee capacity.", "_t")
t("Golem arcane capacity.", "Golem arcane capacity.", "_t")
--]==]

-- untranslated text
--[==[
t("spell", "spell", "talent category")
t("explosive admixtures", "explosive admixtures", "_t")
t("Manipulate gems to turn them into explosive magical bombs.", "Manipulate gems to turn them into explosive magical bombs.", "_t")
t("golemancy", "golemancy", "_t")
t("Learn to craft and upgrade your golem.", "Learn to craft and upgrade your golem.", "_t")
t("advanced-golemancy", "advanced-golemancy", "_t")
t("Advanced golem operations.", "Advanced golem operations.", "_t")
--]==]


------------------------------------------------
section "tome-new-alchemist/data/timed_effects.lua"

t("disrupt", "干扰", "effect subtype")
t("confuse", "混乱", "effect subtype")
t("Disrupted", "被干扰", "_t")
t("Talents fail chance %d%%.", "技能失败率 %d%%。", "tformat")
t("#Target# has been disrupted by the rune!", "#Target# 被符文干扰！", "_t")
t("#Target# is free from the disruption.", "#Target# 不再被干扰。", "_t")
t("arcane", "奥术", "effect subtype")
t("Supercharge Golem", "超载傀儡", "_t")
t("The target is supercharged, increasing speed by %d%%.", "傀儡的速度增加 %d%%。", "tformat")
t("#Target# is overloaded with power.", "#Target# 充满了能量。", "_t")
t("+Supercharge", "+超载傀儡", "_t")
t("#Target# seems less dangerous.", "#Target# 看起来不那么危险了。", "_t")
t("-Supercharge", "-超载傀儡", "_t")
t("Ultimate power", "终极力量", "_t")
t("+Ultimate power", "+终极力量", "_t")
t("-Ultimate power", "-终极力量", "_t")
t("fire", "火焰", "effect subtype")
t("Fire Burnt", "烧伤", "_t")
t("The target is burnt by the fiery fire, reducing damage dealt by %d%%", "目标被火焰烧伤，造成的伤害减少 %d%%。", "tformat")
t("ice", "寒冰", "effect subtype")
t("Frost Shield", "寒霜护盾", "_t")
t("The target is protected by the frost, reducing all damage except fire by %d.", "目标被寒霜保护，除火焰外的伤害降低 %d。", "tformat")
t("%s(%d frost reduce#LAST#%s)#LAST#", "%s(%d 寒霜护盾#LAST#%s)#LAST#", "tformat")
t("nature", "自然", "effect subtype")
t("Stoned Armour", "岩石护甲", "_t")
t("The target's armour has been enchanted, granting %d armour and %d%% armour hardiness, but decreasing defense by %d.", "增加 %d 护甲和 %d%% 护甲强度，减少 %d 闪避。", "tformat")
t("+Stoned Armour", "+岩石护甲", "_t")
t("-Stoned Armour", "-岩石护甲", "_t")
t("Potion of Magic", "魔法药剂", "_t")
t("Pure Magic", "纯净魔力", "_t")
t("The target's spellpower has been increased by %d.", "目标的法术强度增加 %d。", "tformat")
t("+Magic Potion", "+魔法药剂", "_t")
t("-Magic Potion", "-魔法药剂", "_t")
t("Super Lucky", "超级幸运", "_t")
t("Extra %d luck.", "获得额外 %d 幸运。", "tformat")
t("%d%% chance to fully absorb any damaging actions.", "%d%% 概率无视伤害。", "tformat")
t("#Target# is super lucky now.", "#Target# 现在超级幸运。", "_t")
t("+Super Lucky", "+超级幸运", "_t")
t("#Target# seems less lucky.", "#Target# 看起来不那么幸运了。", "_t")
t("-Super Lucky", "-超级幸运", "_t")
t("Swiftness", "迅捷", "_t")
t("Increases movement speed by %d%%, global speed by %d%%.", "移动速度增加 %d%%, 整体速度增加 %d%%.", "tformat")
t("Diamond Speed", "钻石加速", "_t")
t("Gain %d free moves.", "获得 %d 次免费移动。", "tformat")
t("Pearl Armour", "珍珠护甲", "_t")
t("Increases armour by %d.", "增加 %d 护甲。", "tformat")
t("Jade Regeneration", "翡翠回复", "_t")
t("Increases life regeneration by %d per turn.", "增加 %d 生命回复。", "tformat")
t("Emerald Affinity", "祖母绿吸收", "_t")
t("Increases affinity for all damage by %d%%.", "增加伤害吸收 %d%%。", "tformat")
t("Onyx Heal Enchant", "玛瑙治疗强化", "_t")
t("Increases healing factor by %d%%.", "增加治疗系数 %d%%。", "tformat")
t("The target gains ultimate power, increasing stats by %d, and dealing %0.2f elemental damage in radius 6 each turn.", "目标获得了终极力量，属性增加 %d， 每回合对6格内的目标造成 %0.2f 随机元素伤害。", "tformat")
t("Ametrine Defense", "紫晶闪避", "_t")
t("The target's defense is boosted by %d.", "目标闪避上升 %d。", "tformat")
t("Elemental Protection", "元素保护", "_t")
t("Increases %d%% elemental resistance.%s", "增加 %d%% 元素伤害抗性。%s", "tformat")
t(" Blocks fire/cold/lightning/acid detrimental effects", "阻挡火焰/寒冷/闪电/酸性负面状态。", "_t")
t("You have %d power stored.", "你拥有 %d 能量。", "tormat")
-- untranslated text
--[==[
t("#Target#'s skin looks a bit thorny.", "#Target#'s skin looks a bit thorny.", "_t")
t("#Target# is less thorny now.", "#Target# is less thorny now.", "_t")
t("#Target# is surging arcane power.", "#Target# is surging arcane power.", "_t")
t("#Target# is no longer surging arcane power.", "#Target# is no longer surging arcane power.", "_t")
t("tactic", "tactic", "effect subtype")
t("speed", "speed", "effect subtype")
t("healing", "healing", "effect subtype")
t("regeneration", "regeneration", "effect subtype")
t("heal", "heal", "effect subtype")
--]==]

-- old translated text
t("The target gains ultimate power, increasing stats by %d , and dealing %0.2f elemental damage in radius 6 each turn.", "目标获得了终极力量，属性增加 %d， 每回合对6格内的目标造成 %0.2f 随机元素伤害。", "tformat")
t("The target gains ultimate power, increasing stats by %d and damage done by %d%%, and dealing %0.2f elemental damage in radius 6 each turn.", "目标获得了终极力量，属性增加 %d， 伤害增加 %d%%, 每回合对6格内的目标造成 %0.2f 随机元素伤害。", "tformat")

------------------------------------------------
section "tome-new-alchemist/init.lua"

t("New Alchemist", "炼金术士（新版）", "init.lua long_name")
-- untranslated text
--[==[
t("Remake of Alchemist.", "Remake of Alchemist.", "init.lua description")
--]==]


------------------------------------------------
section "tome-new-alchemist/overload/data/chats/choose-elemental_infusion.lua"

t("Choose which element?", "选择哪种元素？", "tformat")
t("Fire.", "火焰", "_t")
t("Cold.", "寒冷", "_t")
t("Acid.", "酸性", "_t")
t("Lightning.", "闪电", "_t")
t("Nothing.", "取消充能", "_t")
t("[Leave]", "[离开]", "_t")
t("Physical.", "物理", "_t")
t("Light.", "光明", "_t")
t("Darkness.", "黑暗", "_t")
t("Arcane.", "奥术", "_t")
-- old translated text
t("Dissolving Acid", "溶解之酸", "talent name")

------------------------------------------------
section "tome-new-alchemist/overload/data/chats/prepare-alchemy-potions.lua"


-- untranslated text
--[==[
t("[Cancel]", "[Cancel]", "_t")
t("#CADET_BLUE#%s already equipped at level %d.", "#CADET_BLUE#%s already equipped at level %d.", "log")
t("#CADET_BLUE#Equipping %s with %s (level %d).", "#CADET_BLUE#Equipping %s with %s (level %d).", "log")
t("[%sEquip %s%s#LAST#]", "[%sEquip %s%s#LAST#]", "tformat")
t("[Equip %s]", "[Equip %s]", "tformat")
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")
t("Equip which tool for #YELLOW#%s#LAST#?", "Equip which tool for #YELLOW#%s#LAST#?", "tformat")
--]==]


------------------------------------------------
section "tome-new-alchemist/overload/data/general/objects/gem.lua"

t("Gain one free move in 2 turns (stacks for 3 times)", "2回合内获得1次免费移动机会（可堆叠至三倍）", "_t")
t("Gain 25 armor in 3 turns (stacks for 3 times)", "3回合内获得25护甲（可堆叠至三倍）", "_t")
t("50% chance to silence for 2 turns", "50% 概率沉默2回合", "_t")
t("Deals %d%% extra fireburn damage", "造成 %d%% 额外火焰燃烧伤害", "tformat")
t("Regen 150 life in 3 turns (stacks for 3 times)", "3回合内回复150生命（可堆叠至三倍）", "_t")
t("50% chance to disarm", "50% 概率缴械", "_t")
t("Deals 12% extra ice damage, may freeze or wet target.", "造成 12% 额外寒冰伤害，可能触发冻结或湿润效果", "_t")
t("Gain affinity for all damage by 5% in 3 turns (stacks for 3 times)", "3回合内获得5%伤害吸收（可堆叠至三倍）", "_t")
t("Deals %d%% extra physical knockback damage", "造成%d%%额外物理击退伤害", "tformat")
t("Increases healing factor by 30% for 3 turns (stacks for 3 times)", "3回合内治疗系数上升30%（可堆叠至三倍）", "_t")
t("50% chance to cleanse one magical debuff", "50%概率解除一项魔法负面状态", "_t")
t("gain 20 defense for 5 turns", "5回合内闪避上升20", "_t")
t("Deals %d%% extra poison damage", "造成%d%%额外毒素伤害", "tformat")
-- untranslated text
--[==[
t("gem", "gem", "entity type")
t("white", "white", "entity subtype")
t("Gems can be sold for money or used in arcane rituals.", "Gems can be sold for money or used in arcane rituals.", "_t")
t("color", "color", "entity subtype")
t("..", "..", "entity name")
t("alchemist-gem", "alchemist-gem", "entity type")
t("diamond", "diamond", "entity name")
t("alchemist diamond", "alchemist diamond", "entity name")
t("blue", "blue", "entity subtype")
t("pearl", "pearl", "entity name")
t("alchemist pearl", "alchemist pearl", "entity name")
t("moonstone", "moonstone", "entity name")
t("alchemist moonstone", "alchemist moonstone", "entity name")
t("violet", "violet", "entity subtype")
t("fire opal", "fire opal", "entity name")
t("alchemist fire opal", "alchemist fire opal", "entity name")
t("red", "red", "entity subtype")
t("jade", "jade", "entity name")
t("alchemist jade", "alchemist jade", "entity name")
t("black", "black", "entity subtype")
t("bloodstone", "bloodstone", "entity name")
t("alchemist bloodstone", "alchemist bloodstone", "entity name")
t("amber", "amber", "entity name")
t("alchemist amber", "alchemist amber", "entity name")
t("turquoise", "turquoise", "entity name")
t("alchemist turquoise", "alchemist turquoise", "entity name")
t("green", "green", "entity subtype")
t("sapphire", "sapphire", "entity name")
t("alchemist sapphire", "alchemist sapphire", "entity name")
t("emerald", "emerald", "entity name")
t("alchemist emerald", "alchemist emerald", "entity name")
t("ruby", "ruby", "entity name")
t("alchemist ruby", "alchemist ruby", "entity name")
t("quartz", "quartz", "entity name")
t("alchemist quartz", "alchemist quartz", "entity name")
t("lapis lazuli", "lapis lazuli", "entity name")
t("alchemist lapis lazuli", "alchemist lapis lazuli", "entity name")
t("onyx", "onyx", "entity name")
t("alchemist onyx", "alchemist onyx", "entity name")
t("amethyst", "amethyst", "entity name")
t("alchemist amethyst", "alchemist amethyst", "entity name")
t("yellow", "yellow", "entity subtype")
t("garnet", "garnet", "entity name")
t("alchemist garnet", "alchemist garnet", "entity name")
t("opal", "opal", "entity name")
t("alchemist opal", "alchemist opal", "entity name")
t("topaz", "topaz", "entity name")
t("alchemist topaz", "alchemist topaz", "entity name")
t("aquamarine", "aquamarine", "entity name")
t("alchemist aquamarine", "alchemist aquamarine", "entity name")
t("ametrine", "ametrine", "entity name")
t("alchemist ametrine", "alchemist ametrine", "entity name")
t("zircon", "zircon", "entity name")
t("alchemist zircon", "alchemist zircon", "entity name")
t("spinel", "spinel", "entity name")
t("alchemist spinel", "alchemist spinel", "entity name")
t("citrine", "citrine", "entity name")
t("alchemist citrine", "alchemist citrine", "entity name")
t("Lights terrain (power 100)", "Lights terrain (power 100)", "_t")
t("agate", "agate", "entity name")
t("alchemist agate", "alchemist agate", "entity name")
--]==]

-- old translated text
t("15% chance to disarm", "15% 概率缴械", "_t")
t("Deals %d%% extra poison damage", "造成%d%%额外毒素伤害", "_t")

------------------------------------------------
section "tome-new-alchemist/overload/mod/class/AddonAlchemist.lua"


-- untranslated text
--[==[
t("#ANTIQUE_WHITE#%s: #ffffff#%d / %d", "#ANTIQUE_WHITE#%s: #ffffff#%d / %d", "tformat")
--]==]


------------------------------------------------
section "tome-new-alchemist/overload/mod/class/uiset/ClassicPlayerDisplay.lua"


-- untranslated text
--[==[
t([[#GOLD##{bold}#%s
#WHITE##{normal}#Life: %d%%
Level: %d
%s]], [[#GOLD##{bold}#%s
#WHITE##{normal}#Life: %d%%
Level: %d
%s]], "tformat")
t([[#{bold}##GOLD#%s
(%s: %s)#WHITE##{normal}#
]], [[#{bold}##GOLD#%s
(%s: %s)#WHITE##{normal}#
]], "tformat")
t("%s reduced the duration of this effect by %d turns, from %d to %d.", "%s reduced the duration of this effect by %d turns, from %d to %d.", "tformat")
t("Really cancel %s?", "Really cancel %s?", "tformat")
t([[#GOLD##{bold}#%s
#WHITE##{normal}#Unused stats: %d
Unused class talents: %d
Unused generic talents: %d
Unused categories: %d]], [[#GOLD##{bold}#%s
#WHITE##{normal}#Unused stats: %d
Unused class talents: %d
Unused generic talents: %d
Unused categories: %d]], "tformat")
t("%s#{normal}#", "%s#{normal}#", "tformat")
t("Level / Exp: #00ff00#%s / %2d%%", "Level / Exp: #00ff00#%s / %2d%%", "tformat")
t("Gold: #00ff00#%0.2f", "Gold: #00ff00#%0.2f", "tformat")
t("Accuracy:", "Accuracy:", "_t")
t("P. power:", "P. power:", "_t")
t("S. power:", "S. power:", "_t")
t("M. power:", "M. power:", "_t")
t("Defense:", "Defense:", "_t")
t("P. save:", "P. save:", "_t")
t("S. save:", "S. save:", "_t")
t("M. save:", "M. save:", "_t")
t("Turns remaining: %d", "Turns remaining: %d", "tformat")
t("Air level: %d/%d", "Air level: %d/%d", "tformat")
t("Encumbered! (%d/%d)", "Encumbered! (%d/%d)", "tformat")
t("Str/Dex/Con: #00ff00#%3d/%3d/%3d", "Str/Dex/Con: #00ff00#%3d/%3d/%3d", "tformat")
t("Mag/Wil/Cun: #00ff00#%3d/%3d/%3d", "Mag/Wil/Cun: #00ff00#%3d/%3d/%3d", "tformat")
t("#c00000#Life    :", "#c00000#Life    :", "_t")
t("#WHITE#Shield:", "#WHITE#Shield:", "_t")
t([[#GOLD#%s#LAST#
%s
]], [[#GOLD#%s#LAST#
%s
]], "tformat")
t("no description", "no description", "_t")
t("%-8.8s:", "%-8.8s:", "tformat")
t("#7fffd4#Feedback:", "#7fffd4#Feedback:", "_t")
t("#c00000#Un.body :", "#c00000#Un.body :", "_t")
t("%0.1f (%0.1f/turn)", "%0.1f (%0.1f/turn)", "tformat")
t("#LIGHT_GREEN#Fortress:", "#LIGHT_GREEN#Fortress:", "_t")
t("#ANTIQUE_WHITE#Ammo    :       #ffffff#%d", "#ANTIQUE_WHITE#Ammo    :       #ffffff#%d", "tformat")
t("#ANTIQUE_WHITE#Ammo    :       #ffffff#%s", "#ANTIQUE_WHITE#Ammo    :       #ffffff#%s", "tformat")
t("#ANTIQUE_WHITE#Ammo    :       #ffffff#%d/%d", "#ANTIQUE_WHITE#Ammo    :       #ffffff#%d/%d", "tformat")
t("Saving:", "Saving:", "_t")
t([[#GOLD##{bold}#%s#{normal}##WHITE#
]], [[#GOLD##{bold}#%s#{normal}##WHITE#
]], "tformat")
t("Score(TOP): %d", "Score(TOP): %d", "tformat")
t("Score: %d", "Score: %d", "tformat")
t("Wave(TOP) %d", "Wave(TOP) %d", "tformat")
t("Wave %d", "Wave %d", "tformat")
t(" [MiniBoss]", " [MiniBoss]", "_t")
t(" [Boss]", " [Boss]", "_t")
t(" [Final]", " [Final]", "_t")
t("Bonus: %d (x%.1f)", "Bonus: %d (x%.1f)", "tformat")
t(" VS", " VS", "_t")
t("Rank: %s", "Rank: %s", "tformat")
--]==]


------------------------------------------------
section "tome-new-alchemist/overload/mod/class/uiset/Minimalist.lua"


-- untranslated text
--[==[
t([[#GOLD#%s#LAST#
%s]], [[#GOLD#%s#LAST#
%s]], "tformat")
t("no description", "no description", "_t")
t("Player Infos", "Player Infos", "_t")
t("Resources", "Resources", "_t")
t("Minimap", "Minimap", "_t")
t("Current Effects", "Current Effects", "_t")
t("Party Members", "Party Members", "_t")
t("Game Log", "Game Log", "_t")
t("Online Chat Log", "Online Chat Log", "_t")
t("Hotkeys", "Hotkeys", "_t")
t("Game Actions", "Game Actions", "_t")
t("#CRIMSON#Interface locked, mouse enabled on the map", "#CRIMSON#Interface locked, mouse enabled on the map", "say")
t("#CRIMSON#Interface unlocked, mouse disabled on the map", "#CRIMSON#Interface unlocked, mouse disabled on the map", "say")
t("Reset interface positions", "Reset interface positions", "_t")
t("Reset UI", "Reset UI", "_t")
t("Reset all the interface?", "Reset all the interface?", "_t")
t([[%s
---
Left mouse drag&drop to move the frame
Right mouse drag&drop to scale up/down
Middle click to reset to default scale%s]], [[%s
---
Left mouse drag&drop to move the frame
Right mouse drag&drop to scale up/down
Middle click to reset to default scale%s]], "tformat")
t("Feedback", "Feedback", "_t")
t("Fortress Energy", "Fortress Energy", "_t")
t("Display/Hide resources", "Display/Hide resources", "_t")
t("Toggle:", "Toggle:", "_t")
t("\
Right click to toggle resources bars visibility", "\
Right click to toggle resources bars visibility", "_t")
t("Score[1st]: %d", "Score[1st]: %d", "tformat")
t("Score: %d", "Score: %d", "tformat")
t("[MiniBoss]", "[MiniBoss]", "_t")
t("[Boss]", "[Boss]", "_t")
t("[Final]", "[Final]", "_t")
t("Wave(TOP) %d %s", "Wave(TOP) %d %s", "tformat")
t("Wave %d %s", "Wave %d %s", "tformat")
t("Bonus: %d (x%.1f)", "Bonus: %d (x%.1f)", "tformat")
t(" VS", " VS", "_t")
t("Rank: ", "Rank: ", "_t")
t("Saving... %d%%", "Saving... %d%%", "tformat")
t("%s reduced the duration of this effect by %d turns, from %d to %d.", "%s reduced the duration of this effect by %d turns, from %d to %d.", "tformat")
t([[#{bold}##GOLD#%s
(%s: %s)#WHITE##{normal}#
]], [[#{bold}##GOLD#%s
(%s: %s)#WHITE##{normal}#
]], "tformat")
t("\
---\
Right click to cancel early.", "\
---\
Right click to cancel early.", "_t")
t("Really cancel %s?", "Really cancel %s?", "tformat")
t([[#GOLD##{bold}#%s
#WHITE##{normal}#Life: %d%%
Level: %d
%s]], [[#GOLD##{bold}#%s
#WHITE##{normal}#Life: %d%%
Level: %d
%s]], "tformat")
t("\
Turns remaining: %s", "\
Turns remaining: %s", "tformat")
t("Lvl %d", "Lvl %d", "tformat")
t([[Toggle for movement mode.
Default: when trying to move onto a creature it will attack if hostile.
Passive: when trying to move onto a creature it will not attack (use ctrl+direction, or right click to attack manually)]], [[Toggle for movement mode.
Default: when trying to move onto a creature it will attack if hostile.
Passive: when trying to move onto a creature it will not attack (use ctrl+direction, or right click to attack manually)]], "_t")
t("Show character infos", "Show character infos", "_t")
t("Click to assign stats and talents!", "Click to assign stats and talents!", "_t")
t("Show available cosmetic & fun microtransation", "Show available cosmetic & fun microtransation", "_t")
t([[Left mouse to move
Right mouse to scroll
Middle mouse to show full map]], [[Left mouse to move
Right mouse to scroll
Middle mouse to show full map]], "_t")
t("Left click to use", "Left click to use", "_t")
t("Right click to configure", "Right click to configure", "_t")
t("Press 'm' to setup", "Press 'm' to setup", "_t")
t("Unbind %s", "Unbind %s", "tformat")
t("Remove this object from your hotkeys?", "Remove this object from your hotkeys?", "_t")
t([[Left mouse to show inventory
Right mouse to show ingredients]], [[Left mouse to show inventory
Right mouse to show ingredients]], "_t")
t("Left mouse to show known talents", "Left mouse to show known talents", "_t")
t("Left mouse to show message/chat log.", "Left mouse to show message/chat log.", "_t")
t([[Left mouse to show quest log.
Right mouse to show all known lore.]], [[Left mouse to show quest log.
Right mouse to show all known lore.]], "_t")
t("Tales of Maj'Eyal Lore", "Tales of Maj'Eyal Lore", "_t")
t("Left mouse to show main menu", "Left mouse to show main menu", "_t")
t("Unlock all interface elements so they can be moved and resized.", "Unlock all interface elements so they can be moved and resized.", "_t")
t("Lock all interface elements so they can not be moved nor resized.", "Lock all interface elements so they can not be moved nor resized.", "_t")
t("Clicking will open#LIGHT_BLUE##{italic}#%s#WHITE##{normal}# in your browser", "Clicking will open#LIGHT_BLUE##{italic}#%s#WHITE##{normal}# in your browser", "_t")
t("Donator", "Donator", "_t")
t("Developer", "Developer", "_t")
t("Moderator / Helper", "Moderator / Helper", "_t")
t("Recurring Donator", "Recurring Donator", "_t")
t("Playing: ", "Playing: ", "_t")
t("Game: ", "Game: ", "_t")
t("Clicking will open ", "Clicking will open ", "_t")
t("Show chat user", "Show chat user", "_t")
t("Whisper", "Whisper", "_t")
t("Ignore", "Ignore", "_t")
t("Ignore user", "Ignore user", "_t")
t("Really ignore all messages from: %s", "Really ignore all messages from: %s", "tformat")
t("Report user for bad behavior", "Report user for bad behavior", "_t")
t("Reason to report: %s", "Reason to report: %s", "tformat")
t("Reason", "Reason", "_t")
t("#VIOLET#", "#VIOLET#", "log")
t("Remove Friend", "Remove Friend", "_t")
t("Really remove %s from your friends?", "Really remove %s from your friends?", "tformat")
t("Add Friend", "Add Friend", "_t")
t("Really add %s to your friends?", "Really add %s to your friends?", "tformat")
--]==]


------------------------------------------------
section "tome-new-alchemist/overload/mod/dialogs/talents/PrepareAlchemistPotion.lua"


-- untranslated text
--[==[
t("Managed readied tools", "Managed readied tools", "_t")
t("", "", "_t")
t("Readied tools", "Readied tools", "_t")
t("Inventory", "Inventory", "_t")
--]==]


------------------------------------------------
section "tome-new-alchemist/superload/data/talents/spells/explosives.lua"


-- untranslated text
--[==[
t("You need to ready alchemist gems in your quiver.", "You need to ready alchemist gems in your quiver.", "logPlayer")
--]==]


------------------------------------------------
section "tome-new-alchemist/superload/data/talents/spells/stone-alchemy.lua"

t([[Invoke your gem to mark impassable terrain next to you. You immediately enter it and appear on the other side of the obstacle, up to %d grids away.]], [[激活宝石来标记一块不可通过区域，你可以立即越过障碍物并出现在另一端，最大范围 %d 格。]], "tformat")
-- untranslated text
--[==[
t("You need to ready 5 alchemist gems in your quiver.", "You need to ready 5 alchemist gems in your quiver.", "logPlayer")
--]==]


------------------------------------------------
section "tome-new-alchemist/superload/mod/class/Actor.lua"

t("You cannot prepare more than one bottle of special potions", "你不能准备多于一瓶特殊药剂。", "logPlayer")

------------------------------------------------
section "tome-new-alchemist/superload/mod/class/Object.lua"

t("Gem related talents", "宝石相关技能", "_t")

