locale "zh_hans"
t("New Alchemist", "炼金术士（新版）", "birth descriptor name")
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
t("Elixir Potion", "精华药剂", "talent name")
t("Magical Potion", "魔法药剂", "talent name")
t("Ingredient Recycle", "材料回收", "talent name")
t([[You know how to reuse the remain of your potions.
        After throwing bomb, you have %d%% chance to reproduce a random potion.]], [[你学会了回收利用材料。
        投掷炸弹后，有 %d%% 概率随机制造一瓶药剂。]], "tformat")


t([[%s
        Left charges: %d]], [[%s
        剩余次数: %d]], "tformat")
t("Throw the smoke bomb.", "投掷烟雾弹。", "tformat")
t([[Throw a smoke bomb, blocking everyone's line of sight. The smoke dissipates after %d turns.
        Duration will increase with your Spellpower.]], [[投掷烟雾弹，阻挡视线。烟雾持续 %d 回合。
        持续时间受法术强度加成。]], "tformat")
t("Healing Potion", "治疗药剂", "talent name")
t("Heal and cure, rid of poison and diseases.", "治疗，并解除毒素和疾病。", "tformat")
t([[Heal target for %d life and cure all poisons、diseases and wounds.
        The amount healed will increase with your Spellpower.]], [[治疗目标 %d 生命，并解除全部疾病、毒素和伤口状态。
        治疗量受法术强度加成。]], "tformat")
t("Fiery Wall", "火焰之墙", "talent name")
t("fire wall", "火墙", "_t")
t("Create a fire wall that burns nearby foe", "制造火焰墙灼烧周围敌人", "_t")
t("a summoned, transparent wall of fire", "一堵透明的火焰墙。", "_t")
t("%s conjures a wall of fire!", "%s 制造出火焰之墙！", "logSeen")
t([[Create a fiery wall of %d length that lasts for %d turns.
        Fire walls may burn any enemy in %d radius, each wall within range deals %d fire damage.
        Burnt enemy will deal %d%% less damage in 3 turns.
        Fire wall does not block movement.]], [[制造出炽热的火焰墙，长度为 %d ，持续 %d 回合。
        火墙将灼烧周围 %d 格内的目标，每块火焰将造成 %d 伤害。
        被火焰烧伤的敌人在 3 回合内造成的伤害减少 %d%% 。
        火墙不会阻挡移动。]], "tformat")
t("Throw bottle of acid that removes sustain", "投掷酸液，解除对方的维持状态。", "_t")
t([[Acid erupts all around your target, dealing %0.1f acid damage.
		The acid attack is extremely distracting, and may remove up to %d sustains (depending on the Spell Save of the target).
		The damage and chance to remove effects will increase with your Spellpower.]], [[酸液在目标周围爆发，造成 %0.1f 点酸性伤害。
		酸性伤害具有腐蚀性，有一定概率除去至多 %d 个持续效果（需要通过对方的法术豁免）。
                受法术强度影响，伤害和几率额外加成。]], "tformat")
t("Lightning Ball", "闪电球", "talent name")
t("Throw a ball of lightning, daze and blind all targets.", "投掷闪电球，眩晕并致盲目标。", "tformat")
t([[Throw a ball of lightning of radius %d, daze and blind all targets for %d turns.
        If the target resists the daze effect it is instead shocked, which halves stun/daze/pin resistance, for %d turns.
        ]], [[投掷半径 %d 的闪电球，眩晕并致盲目标 %d 回合。
        如果目标免疫了眩晕，则会被闪电震撼，减半震慑和定身免疫，持续 %d 回合。
        ]], "tformat")
t("Breath of the Frost", "冰霜之息", "talent name")
t("Create a frost shield reducing damage and critical hits", "制造寒冰护盾，减少伤害。", "tformat")
t([[Create a frost shield in range %d, reducing %d%% all incoming damage except fire, and reducing direct critical damage by %d%%.
        Frost shield lasts %d turns.]],
"为 %d 格范围内的生物制造寒冰护盾，减少 %d%% 火焰以外的伤害，并降低 %d%% 受到的暴击伤害，持续 %d 回合", "tformat")


t("Manage Elemental Infusion", "调整元素充能", "talent name")
t("Choose your element", "选择元素", "_t")
t("Manage your elemental infusion.", "调整元素充能。", "_t")
t("Elemental Infusion", "元素充能", "talent name")
t([[When you throw your alchemist bombs, you infuse them with %s.
		In addition, %s damage you do is increased by %d%% .
		You may choose your infusion in following elements: fire, cold, lightning and acid.]], [[投掷炸弹时，用 %s 能量填充之。
        此外，你造成的 %s 伤害提升 %d%% 。
        你可以选择以下元素：火焰、寒冷、闪电和酸性。]], "tformat")
t("Infusion Enchantment", "充能强化", "talent name")
t([[You alchemist bomb now has a %d%% chance to disable your foes for %d turns, the infliced effect changes with your elemental infusion:
        -- Fire: Stun
        -- Cold: Frozen feet
        -- Acid: Blind
        -- Lightning: Daze
        This can trigger every %d turns.
        ]], [[你的炼金炸弹有 %d%% 触发 %d 回合的控制效果:
        -- 火焰: 震慑
        -- 寒冷: 冻足
        -- 酸性: 致盲
        -- 闪电: 眩晕
        该效果每 %d 回合只能触发一次。
        ]], "tformat")
t("Energy Recycle", "能量循环", "talent name")
t([[If you have chosen your elemental infusion, every time you deal damage the same type as your infusion, you have %d%% chance to reduce the remaining cooldown of your bomb by %d turns. Besides, you may lower your targets' defense, reducing saves and defensed by %d for 3 turns.
        You must deal more than %d damage to trigger this effect.
        Cooldown reduction can happen once per turn.
        ]], [[当你选择充能后，每次造成相同类型伤害时，有 %d%% 概率减少投掷炸弹的冷却时间 %d 回合。此外，你还可以降低敌人的防御能力，豁免和闪避下降 %d ，持续 3 回合。
        伤害值必须超过 %d 才能触发该效果。
        冷却时间缩短效果每回合最多触发一次。
        ]], "tformat")
t("Body of Element", "元素之躯", "talent name")
t([[You body turn into pure element.
        You gain %d%% resistance, %d%% resistance penetration for the specific element you choose.
        Every turn, a random elemental bolt will hit up to %d of your foes in radius 6, dealing %0.2f %s damage.
        ]], [[你的身体部分转化为纯粹的元素形态。
        对指定充能元素获得 %d%% 抗性， %d%% 抗性穿透。
        此外，每回合开始时，对6格范围内至多 %d 名随机敌人造成 %0.2f %s 伤害。
        ]], "tformat")



------------------------------------------------
section "tome-new-alchemist/data/talents/spells/gem-spell.lua"

t("Gem Blast", "宝石爆破", "talent name")
t("You need to ready gems in your quiver.", "你需要准备宝石。", "logPlayer")
t([[Deals %0.2f %s damage to target.
        If this attack hits, it will trigger the special effect of gem.
        This talent can be activated even in silence.
        Using this talent will disable One with Gem for 5 turns.
        The damage scales with your gem tier, and the damage type changes with your gem.
        This spell cannot crit.
        ]], [[对目标造成 %0.2f %s 伤害。
        如果攻击命中，则会触发宝石的特殊效果。
        该技能不受沉默影响，但不能暴击。
        使用该技能将暂时取消宝石协调的效果 5 回合。
        伤害和伤害类型受宝石影响。
        ]], "tformat")
t("Gem's Radiance", "宝石光辉", "talent name")
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
t("Flickering Gem", "闪烁宝石", "talent name")
t("You cannot summon; you are suppressed!", "You cannot summon; you are suppressed!", "logPlayer")
t([[Invoke the power of your gem, summon %d crystal around you for %d turns.
        Then randomly select target in radius 10 and trigger the special effect of gem.
        This talent can be activated even in silence.
        Using this talent will disable One with Gem for 5 turns.
        Summon duration scales with your gem.
        ]], [[激活宝石的能量，在你身边召唤 %d 个水晶，持续 %d 回合。
        如果周围10格内有敌人，则会触发宝石的特殊效果。
        该技能不受沉默影响，但不能暴击。
        使用该技能将暂时取消宝石协调的效果 5 回合。
        召唤时长受宝石影响。
        ]], "tformat")
t("One with Gem", "宝石协调", "talent name")
t("This has beed disabled for %d turns", "该技能在 %d 回合内不会触发。", "tformat")
t([[When you dealt damage the same type as your gem, you may trigger the special effect of your gem.
        This can happen every %d turns.
        %s]], [[当你造成和宝石的潜在伤害类型一致的伤害时，你可以触发宝石的特殊效果。
        该技能每 %d 回合最多触发一次。
        %s]], "tformat")


------------------------------------------------
section "tome-new-alchemist/data/talents/spells/new-advanced-golemancy.lua"


t("Supercharge Golem", "超载傀儡", "talent name")
t("Your golem is currently inactive.", "你的傀儡暂时处于未激活状态。", "logPlayer")
t([[You activate a special mode of your golem, boosting its speed by %d%% for %d turns.
        While supercharged, your golem is enraged and deals %d%% more damage.
        Damage boost scales with your spellpower.]], [[激活傀儡，加速 %d%%， 持续 %d 回合。
        同时，傀儡造成的伤害增加 %d%% 。
        伤害加成随法术强度增加。]], "tformat")
t("Golem Portal", "傀儡传送", "talent name")
t("#Target# focuses on #Source#.", "#Target# focuses on #Source#.", "logCombat")
t([[Teleport to your golem, while your golem teleports to your location. Your foes will be confused, and those that were attacking you will have a %d%% chance to target your golem instead.
        After teleportation, you and your golem gain 50%% evasion for %d turns.]], [[交换你和傀儡的位置，敌人有 %d%% 概率选择傀儡为目标。
        传送后，你和傀儡获得 50%% 闪避， 持续 %d 回合。]], "tformat")
t("Disruption Rune", "干扰符文", "talent name")
t([[You activate the disruptive rune in your golem, foes in radius %d will be disrupted for %d turns, their talents have 50%% chance to fail.
        ]], [[你激活傀儡身上的干扰符文，你和傀儡 %d 格范围内的敌人将受到 %d 回合的干扰，技能成功率下降 50%% 。
        ]], "tformat")
t("Golem's Fury", "傀儡之怒", "talent name")
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
section "tome-new-alchemist/data/talents/spells/new-explosive.lua"


t("Throw Bomb", "炸弹投掷", "talent name")
t([[Imbue an alchemist gem with an explosive charge of mana and throw it.
		The gem will explode for %0.1f %s damage.
		Each kind of gem will also provide a specific effect.
		The damage will improve with better gems and with your Spellpower.]], [[向一块宝石内灌输爆炸能量并扔出它。 
		宝石将会爆炸并造成 %0.1f 的 %s 伤害。 
		每个种类的宝石都会提供一个特殊的效果。 
		伤害受宝石品质和法术强度加成。]], "tformat")
t("Alchemist Protection", "炼金保护", "talent name")
t("Grants protection against external elemental damage (fire, cold, lightning and acid) by %d%%.", "提高对外界元素（火焰、寒冷、闪电和酸性）伤害的抗性 %d%% 。", "tformat")
t("Explosion Expert", "爆破专家", "talent name")
t([[Your alchemist bombs now affect a radius of %d around them.
		Explosion damage may increase by %d%% (if the explosion is not contained) to %d%% if the area of effect is confined.]], [[炼金炸弹的爆炸半径现在增加 %d 码。
		增加 %d%% （地形开阔）～ %d%% （地形狭窄）爆炸伤害。]], "tformat")
t("Chain Blasting", "连环爆破", "talent name")
t([[Your alchemist bombs now have %d%% chance to not go on cooldown.
        Chances increases with your gem tier.]], [[炸弹投掷有 %d%% 概率不进入冷却。
        几率受宝石品质加成。]], "tformat")


------------------------------------------------
section "tome-new-alchemist/data/talents/spells/new-golemancy.lua"


t("Master must know the Runic Golem talent", "主人必须学会符文傀儡技能", "_t")
t("Master's Runic Golem talent too low for this gem", "主人的符文傀儡技能等级过低", "_t")
t("Gem Golem", "宝石傀儡", "talent name")
t("Golem's armor is increased by 6 per gem's tier, and resistance is increased by 3 per gem's tier.", "宝石每层级提供6点护甲和3%%全体伤害抗性。", "tformat")
t("Golem Power", "傀儡之力", "talent name")
t("Improves your golem's proficiency with weapons, increasing its attack and damage. Then Improves your golem's armour training, damage resistance, and healing efficiency.",
 "提高傀儡的武器熟练度，增加其命中和伤害。提高傀儡护甲熟练度、伤害抗性和治疗系数。", "_t")
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
        If your golem is below 50%% life, it will gain a shield which can absorb %d damage for 5 turns.]], [[激活宝石的能量，治疗你和傀儡 %d 生命。
        如果傀儡已经死亡，则以 50%% 血量复活之。
        如果傀儡血量少于 50%% ，则额外获得 %d 吸收量的护盾，持续5回合。]], "tformat")
t("Dynamic Recharge", "动态充能", "talent name")
t("%s is energized by the attack, reducing some talent cooldowns!", "%s is energized by the attack, reducing some talent cooldowns!", "logSeen")
t([[Your bombs energize your golem.
		All talents on cooldown on your golem have %d%% chance to be reduced by %d.]], [[你的炸弹会给傀儡充能。
		你的傀儡的所有冷却中技能有 %d%% 概率减少 %d 回合冷却时间。]], "tformat")



------------------------------------------------
section "tome-new-alchemist/data/talents/spells/spells.lua"

t("elemental alchemy", "元素炼金", "_t")
t("Alchemical spells designed to wage war.", "为战争设计的炼金法术。", "_t")
t("gem spell", "宝石法术", "_t")
t("invoke your gem power.", "激活宝石的能量。", "_t")
t("alchemy potions", "炼金药剂", "_t")
t("prepare some alchemy potions.", "准备炼金药剂。", "_t")
t("some useful alchemy potions.", "有用的炼金药剂。", "_t")



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
t("The target is supercharged, increasing speed by %d%% and damage done by %d%%.", "速度增加 %d%%，伤害增加 %d%%。", "tformat")
t("#Target# is overloaded with power.", "#Target# 充满了能量。", "_t")
t("+Supercharge", "+超载傀儡", "_t")
t("#Target# seems less dangerous.", "#Target# 看起来不那么危险了。", "_t")
t("-Supercharge", "-超载傀儡", "_t")
t("Ultimate power", "终极力量", "_t")
t("The target gains ultimate power, increasing stats by %d and damage done by %d%%, and dealing %0.2f elemental damage in radius 6 each turn.", 
"目标获得了终极力量，属性增加 %d， 伤害增加 %d%%, 每回合对6格内的目标造成 %0.2f 随机元素伤害。", "tformat")
t("+Ultimate power", "+终极力量", "_t")
t("-Ultimate power", "-终极力量", "_t")
t("fire", "火焰", "effect subtype")
t("Fire Burnt", "烧伤", "_t")
t("The target is burnt by the fiery fire, reducing damage dealt by %d%%", "目标被火焰烧伤，造成的伤害减少 %d%%。", "tformat")
t("ice", "寒冰", "effect subtype")
t("Frost Shield", "寒霜护盾", "_t")
t("The target is protected by the frost, reducing all damage except fire by %d%%, and reducing critical damage received by %d%%.", 
"目标被寒霜保护，除火焰外的伤害降低 %d%%，受到的暴击伤害减少 %d%%。", "tformat")
t("%s(%d frost reduce#LAST#%s)#LAST#", "%s(%d 寒霜护盾#LAST#%s)#LAST#", "tformat")


------------------------------------------------
section "tome-new-alchemist/overload/data/chats/choose-elemental_infusion.lua"


t("Choose which element?", "选择哪种元素？", "tformat")
t("Fire.", "火焰", "_t")
t("Cold.", "寒冷", "_t")
t("Acid.", "酸性", "_t")
t("Lightning.", "闪电", "_t")
t("Nothing.", "取消充能", "_t")
t("[Leave]", "[离开]", "_t")

t("Dissolving Acid", "溶解之酸", "talent name")