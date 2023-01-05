#SingleInstance Force
#NoTrayIcon

global mNumSpellHotkeys := 10
global mNumItemHotkeys := 10
global mNumEqpHotKeys := 9
global mNumKeyMaps := 10

global subScriptPID := -1

startERA11y() {
    if (subScriptPID != -1) {
	    Process, close, %subScriptPID%
	}
	Run ER_A11y.ahk,,, PID
	subScriptPID := PID
    GuiControl,, BtnStart, 更新
}

stopERA11y() {
    if (subScriptPID != -1) {
	    Process, close, %subScriptPID%
	}
	subScriptPID := -1
    GuiControl,, BtnStart, 开始
}

genListBoxParamFromDict(useK1orV0, dict) {
	tmp := "|"
	for k in dict {
		append := useK1orV0? k: dict.Item(k)
		tmp .= append
		tmp .= "|"
	}
	return tmp
}

getValueIndexFromDict(dict, value, resultOffset) {
	for k in dict {
		v := dict.Item(k)
		if (k) and (value = v) {
			return % (A_Index + resultOffset)
		}
	}
	return resultOffset
}

addTitle(title, yOffset) {
    Gui, font, s10 bold
    Gui, Add, Text, xm+10 y+%yOffset% h18 0x200, % title
    Gui, font
}

; 初始化可选按键的配置
global combine_keys_map := ComObjCreate("Scripting.Dictionary")
combine_keys_map.Add("空格", "Space")
combine_keys_map.Add("左 Control", "LCtrl")
combine_keys_map.Add("右 Control", "RCtrl")
combine_keys_map.Add("左 Shift", "LShift")
combine_keys_map.Add("右 Shift", "RShift")
combine_keys_map.Add("左 Alt", "LAlt")
combine_keys_map.Add("右 Alt", "RAlt")
combine_keys_list_box_value := genListBoxParamFromDict(1, combine_keys_map)

global single_keys_map := ComObjCreate("Scripting.Dictionary")
single_keys_map.Add("Esc", "Esc")
single_keys_map.Add("Tab", "Tab")
single_keys_map.Add("上", "Up")
single_keys_map.Add("下", "Down")
single_keys_map.Add("左", "Left")
single_keys_map.Add("右", "Right")
single_keys_map.Add("1", "1")
single_keys_map.Add("2", "2")
single_keys_map.Add("3", "3")
single_keys_map.Add("4", "4")
single_keys_map.Add("5", "5")
single_keys_map.Add("6", "6")
single_keys_map.Add("7", "7")
single_keys_map.Add("8", "8")
single_keys_map.Add("9", "9")
single_keys_map.Add("0", "0")
single_keys_map.Add("小键盘0", "Numpad0")
single_keys_map.Add("小键盘1", "Numpad1")
single_keys_map.Add("小键盘2", "Numpad2")
single_keys_map.Add("小键盘3", "Numpad3")
single_keys_map.Add("小键盘4", "Numpad4")
single_keys_map.Add("小键盘5", "Numpad5")
single_keys_map.Add("小键盘6", "Numpad6")
single_keys_map.Add("小键盘7", "Numpad7")
single_keys_map.Add("小键盘8", "Numpad8")
single_keys_map.Add("小键盘9", "Numpad9")
single_keys_map.Add("小键盘.", "NumpadDot")
single_keys_map.Add("小键盘+", "NumpadAdd")
single_keys_map.Add("小键盘-", "NumpadSub")
single_keys_map.Add("小键盘*", "NumpadMult")
single_keys_map.Add("小键盘/", "NumpadDiv")
single_keys_map.Add("F1", "F1")
single_keys_map.Add("F2", "F2")
single_keys_map.Add("F3", "F3")
single_keys_map.Add("F4", "F4")
single_keys_map.Add("F5", "F5")
single_keys_map.Add("F6", "F6")
single_keys_map.Add("F7", "F7")
single_keys_map.Add("F8", "F8")
single_keys_map.Add("F9", "F9")
single_keys_map.Add("F10", "F10")
single_keys_map.Add("F11", "F11")
single_keys_map.Add("F12", "F12")
single_keys_map.Add("A", "a")
single_keys_map.Add("B", "b")
single_keys_map.Add("C", "c")
single_keys_map.Add("D", "d")
single_keys_map.Add("E", "e")
single_keys_map.Add("F", "f")
single_keys_map.Add("G", "g")
single_keys_map.Add("H", "h")
single_keys_map.Add("I", "i")
single_keys_map.Add("J", "j")
single_keys_map.Add("K", "k")
single_keys_map.Add("L", "l")
single_keys_map.Add("M", "m")
single_keys_map.Add("N", "n")
single_keys_map.Add("O", "o")
single_keys_map.Add("P", "p")
single_keys_map.Add("Q", "q")
single_keys_map.Add("R", "r")
single_keys_map.Add("S", "s")
single_keys_map.Add("T", "t")
single_keys_map.Add("U", "u")
single_keys_map.Add("V", "v")
single_keys_map.Add("W", "w")
single_keys_map.Add("X", "x")
single_keys_map.Add("Y", "y")
single_keys_map.Add("Z", "z")
single_keys_list_box_value := genListBoxParamFromDict(1, single_keys_map)

global all_keys_map := ComObjCreate("Scripting.Dictionary")
for k in combine_keys_map
	all_keys_map.Add(k, combine_keys_map.Item(k))
for k in single_keys_map
	all_keys_map.Add(k, single_keys_map.Item(k))
StringTrimRight, temp, combine_keys_list_box_value, 1 ; 去除最后的 | 符号
all_keys_list_box_value := temp . single_keys_list_box_value


; 创建 GUI
Gui, Add, Tab3, w456 h320, 常规|法术|消耗品|装备|按键映射|说明

Gui, Tab, 
Gui, Add, Button, Default w80 xm+188 y+4 vBtnStart gOnBtnApplyClicked, 开始


; 常规设置
Gui, Tab, 1

addTitle("选择游戏", 10)
Gui, Add, Radio, x+24 h18 0x200 vRbER gOnERChecked, 艾尔登法环
Gui, Add, Radio, x+24 h18 0x200 vRbDS3 gOnDS3Checked, 黑暗之魂3

; 翻滚设置
addTitle("分离奔跑和翻滚按键", 10)
Gui, Add, Text, xm+16 y+8 h18 0x200, 游戏的翻滚键
Gui, Add, DropDownList, x+8 vDodgingKeyInGame, %all_keys_list_box_value%

Gui, Add, Text, x+8 h18 0x200, 新的翻滚键
Gui, Add, DropDownList, x+8 vDodgingKeyDetached, %all_keys_list_box_value%
Gui, Add, Text, xm+16 y+8, 　　游戏的翻滚操作是在按下并松开翻滚键后触发的，如果松开较慢，则会出`n现翻滚延迟。这里可以设置一个新的翻滚键，当按下它时，会立刻发送按下翻`n滚键和松开翻滚键2个操作，实现在按下时触发翻滚。

; 通用设置
addTitle("通用", 10)
Gui, Add, Text, xm+16 y+8 h18 0x200, 游戏的菜单键
Gui, Add, DropDownList, x+8 vMenuKeyInGame, %single_keys_list_box_value%

Gui, Add, Text, xm+16 y+8 h18 0x200, 游戏的确认键
Gui, Add, DropDownList, x+8 vConfirmKeyInGame, %single_keys_list_box_value%

Gui, Add, Text, xm+16 y+8 h18 0x200, 切换法术和消耗品的间隔时间
Gui, Add, Edit, r1 vClickInterval x+8 w135 Number
Gui, Add, Text, xm+16 y+8, 　　切换法术和消耗品时，两次切换操作的间隔时间(毫秒)。数值越低，切换`n速度越快，但可能因为游戏掉帧而导致一些切换操作被忽略，出现切换错误的`n情况。至少设置为 30 以上。


; 法术设置
Gui, Tab, 2

Gui, Add, Text, xm+10 y+8 h18 0x200, 为每一个法术设置单独的选择按键
Loop %mNumSpellHotkeys% {
    pos = x+8
    if (A_Index = 1) {
        pos = xm+10 y+8
    } else if (A_Index = 6) {
        pos = xm+10 y+4
    }
    Gui, Add, Edit, r1 vEquippedSpell%A_Index% w80 %pos%
}

Gui, Add, Text, xm+10 y+10 h18 0x200, ↑填写你记忆的法术　　　　　　　　　　　　　　　　　设置各个法术的按键↓
Loop %mNumSpellHotkeys% {
    pos = x+8
    if (A_Index = 1) {
        pos = xm+10 y+8
    } else if (A_Index = 6) {
        pos = xm+10 y+4
    }
    Gui, Add, DropDownList, vSwitchSpellKeyDetached%A_Index% w80 %pos%, % single_keys_list_box_value
}

Gui, Add, Text, xm+10 y+8 h18 0x200, 游戏的切换法术键　
Gui, Add, DropDownList, x+8 vSwitchSpellKey, %all_keys_list_box_value%

Gui, Add, Text, xm+10 y+8 h18 0x200, 名称显示区域　　　
Gui, Add, Edit, r1 vSpellNameRegion x+8 w135
Gui, Add, Text, cRed, 如果设置不正确，程序将总是通过长按切换键来切换。
Gui, Add, Text, y+0, 如果你遇到上述问题，请使用PS、截图等工具测量该值。
Gui, Add, Text, y+0, 要了解测量方法，请查看
Gui, Add, Text, x+0 cBlue gTextMeasureTipsClicked, 显示区域测量


; 消耗品设置
Gui, Tab, 3

Gui, Add, Text, xm+10 y+8 h18 0x200, 为每一个消耗品设置单独的选择按键
Loop %mNumItemHotkeys% {
    pos = x+8
    if (A_Index = 1) {
        pos = xm+10 y+8
    } else if (A_Index = 6) {
        pos = xm+10 y+4
    }
    Gui, Add, Edit, r1 vEquippedItem%A_Index% w80 %pos%
}

Gui, Add, Text, xm+10 y+10 h18 0x200, ↑填写你携带的消耗品　　　　　　　　　　　　　　　设置各个消耗品的按键↓
Loop %mNumItemHotkeys% {
    pos = x+8
    if (A_Index = 1) {
        pos = xm+10 y+8
    } else if (A_Index = 6) {
        pos = xm+10 y+4
    }
    Gui, Add, DropDownList, vSwitchItemKeyDetached%A_Index% w80 %pos%, % single_keys_list_box_value
}

Gui, Add, Text, xm+10 y+8 h18 0x200, 游戏的切换消耗品键
Gui, Add, DropDownList, x+8 vSwitchItemKey, %all_keys_list_box_value%

Gui, Add, Text, xm+10 y+8 h18 0x200, 名称显示区域　　　
Gui, Add, Edit, r1 vItemNameRegion x+8 w135
Gui, Add, Text, cRed, 如果设置不正确，程序将总是通过长按切换键来切换。
Gui, Add, Text, y+0, 如果你遇到上述问题，请使用PS、截图等工具测量该值。
Gui, Add, Text, y+0, 要了解测量方法，请查看
Gui, Add, Text, x+0 cBlue gTextMeasureTipsClicked, 显示区域测量


; 武器设置
Gui, Tab, 4

global equipment_types := ComObjCreate("Scripting.Dictionary")
equipment_types.Add("右手武器1", "0_0")
equipment_types.Add("右手武器2", "1_0")
equipment_types.Add("右手武器3", "2_0")
equipment_types.Add("右手武器1双持", "0_0_twohand")
equipment_types.Add("右手武器2双持", "1_0_twohand")
equipment_types.Add("右手武器3双持", "2_0_twohand")
equipment_types.Add("左手武器1", "0_1")
equipment_types.Add("左手武器2", "1_1")
equipment_types.Add("左手武器3", "2_1")
equipment_types.Add("防具1", "0_2")
equipment_types.Add("防具2", "1_2")
equipment_types.Add("防具3", "2_2")
equipment_types.Add("防具4", "3_2")
equipment_types.Add("护符1", "0_3")
equipment_types.Add("护符2", "1_3")
equipment_types.Add("护符3", "2_3")
equipment_types.Add("护符4", "3_3")
equipment_types.Add("弓箭1", "3_0")
equipment_types.Add("弓箭2", "4_0")
equipment_types.Add("弩箭1", "3_1")
equipment_types.Add("弩箭2", "4_1")
equipment_types_list_box_value := genListBoxParamFromDict(1, equipment_types)

global equipment_positions := ComObjCreate("Scripting.Dictionary")
Loop 6 {
    row := A_Index
    Loop 5 {
        cloumn := A_Index
        key = 行%row% 列%cloumn%
        value := cloumn-1 . "_" . row-1
        equipment_positions.Add(key, value)
    }
}
equipment_positions_list_box_value := genListBoxParamFromDict(1, equipment_positions)

Gui, Add, Text, xm+10 y+8 h18 0x200, 快速切换武器、防具或护符

Gui, Add, Text, xm+10 y+8 h18 0x200, 装备显示区域
Gui, Add, Edit, r1 vEquipmentRegion x+8 w135
Gui, Add, Text, x+8 h18 0x200, 如果切换失败，请查看
Gui, Add, Text, x+0 h18 0x200 cBlue gEqpMeasureTipsClicked, 显示区域测量

Loop %mNumEqpHotKeys% {
    Gui, Add, Text, xm+10 y+8 h18 0x200, 快捷键
    Gui, Add, DropDownList, x+8 w80 vEqpKey%A_Index%, %single_keys_list_box_value%

    Gui, Add, Text, x+8 h18 0x200, 装备类型
    Gui, Add, DropDownList, x+8 w80 vEqpType%A_Index%, %equipment_types_list_box_value%

    Gui, Add, Text, x+8 h18 0x200, 装备位置
    Gui, Add, DropDownList, x+8 w80 vEqpPos%A_Index%, %equipment_positions_list_box_value%

    Gui, Add, Button, x+8 w18 h17 vClearEqp_%A_Index% gClearEqp, ✕
}

; 按键映射
Gui, Tab, 5

Gui, Add, Text, xm+10 y+8 h18 0x200, 对原本的按键不做任何改动，并新增一个按键来实现相同功能
Loop %mNumKeyMaps% {
    Gui, Add, Text, xm+10 y+8 h18 0x200, 游戏的按键
    Gui, Add, DropDownList, x+8 w128 vKmGameKey%A_Index%, %all_keys_list_box_value%

    Gui, Add, Text, x+32 h18 0x200, 新的按键
    Gui, Add, DropDownList, x+8 w128 vKmNewKey%A_Index%, %all_keys_list_box_value%

    Gui, Add, Button, x+8 w18 h17 vClearKeyMap_%A_Index% gClearKeyMap, ✕
}

; 说明
Gui, Tab, 6
Gui, Add, Text, xm+10 y+8 h18 0x200, 注意：　
Gui, Add, Text, y+8, 1. 程序的原理是屏幕文字识别和模拟按键操作，与游戏进程无任何关系。`n`n2. 当法术或消耗品的名称与背景的颜色区别不大时 (例如，在化圣雪原里)，`n   文字识别可能失败，造成切换变慢或者错误。`n`n3. 未识别到文字时，将长按切换键回到第一项，然后再切换到指定项。`n`n4. 如果游戏的翻滚键是 Shift，在角色奔跑(按住翻滚键)时，再按下小键盘`n   的快捷键，可能会导致角色停止奔跑。`n`n5. 切换法术和消耗品功能可能不兼容英文游戏界面。

Gui, Add, Text, xm+10 y+16 h18 0x200, 其他：　
Gui, Add, Text, y+8, 1. 此程序是一个开源项目
Gui, Add, Text, y+0 cBlue gMyGithubClicked, 　 https://github.com/ccr1sa/EldenRing_A11y
Gui, Add, Text, y+10, 2. 感谢光学字符识别库 PaddleOCR
Gui, Add, Text, y+0 cBlue gPaddleGithubClicked, 　 https://github.com/telppa/PaddleOCR-AutoHotkey

Gui Show, w480 h360, EldenRing Accessibility

if (!FileExist("Dll\\PaddleOCR.dll")) {
    MsgBox, % "未下载文字识别库，切换法术和消耗品将变得缓慢"
}

; 获取选择的游戏与配置文件
iniRead, EREnabled, ER_A11y.ini, Common, enabled
iniRead, DS3Enabled, ER_A11y_DS3.ini, Common, enabled
global mCurrentCheckedGame := EREnabled = 1? 1: 2
global mCurrentIniFile := EREnabled = 1? "ER_A11y.ini": "ER_A11y_DS3.ini"
if (mCurrentCheckedGame = 1) {
    GuiControl,, RbER, 1
} else {
    GuiControl,, RbDS3, 1
}

initUI()
return

initUI() {
    initCommon()
    initSpells()
    initItems()
    initEqp()
    initKeyMap()
}

initCommon() {
    iniRead, dodgingKeyInGame, %mCurrentIniFile%, Dodging, key_in_game
    GuiControl, Choose, DodgingKeyInGame, % getValueIndexFromDict(all_keys_map, dodgingKeyInGame, 1)

    iniRead, dodgingKeyDetached, %mCurrentIniFile%, Dodging, key_detached
    GuiControl, Choose, DodgingKeyDetached, % getValueIndexFromDict(all_keys_map, dodgingKeyDetached, 1)

    iniRead, menuKeyInGame, %mCurrentIniFile%, Common, menu_button
    GuiControl, Choose, MenuKeyInGame, % getValueIndexFromDict(single_keys_map, menuKeyInGame, 1)

    iniRead, confirmKeyInGame, %mCurrentIniFile%, Common, confirm_button
    GuiControl, Choose, ConfirmKeyInGame, % getValueIndexFromDict(single_keys_map, confirmKeyInGame, 1)

    iniRead, clickInterval, %mCurrentIniFile%, Common, click_interval
    GuiControl, Text, ClickInterval, % clickInterval
}

initSpells() {
    iniRead, equippedSpells, %mCurrentIniFile%, Spells, equipped_spells
    equippedSpellArray := StrSplit(equippedSpells, ";")
    Loop %mNumSpellHotkeys% {
        GuiControl, Text, EquippedSpell%A_Index%, % equippedSpellArray[A_Index]
    }

    iniRead, switchSpellKeysDetached, %mCurrentIniFile%, Spells, key_detached
    switchSpellKeyArray := StrSplit(switchSpellKeysDetached, ";")
    Loop %mNumSpellHotkeys% {
        GuiControl, Choose, SwitchSpellKeyDetached%A_Index%, % getValueIndexFromDict(single_keys_map, switchSpellKeyArray[A_Index], 1)
    }

    iniRead, switchSpellButton, %mCurrentIniFile%, Spells, switch_spell_button
    GuiControl, Choose, SwitchSpellKey, % getValueIndexFromDict(all_keys_map, switchSpellButton, 1)

    iniRead, spellNameRegion, %mCurrentIniFile%, Spells, spell_name_region
    if (!spellNameRegion) { ; 未设置分辨率，尝试从配置文件中寻找预设值
        spellNameRegion := findTextRegion(0)
    }
    GuiControl, Text, SpellNameRegion, % spellNameRegion
}

initItems() {
    iniRead, equippedItems, %mCurrentIniFile%, Items, equipped_items
    equippedItemArray := StrSplit(equippedItems, ";")
    Loop %mNumItemHotkeys% {
        GuiControl, Text, EquippedItem%A_Index%, % equippedItemArray[A_Index]
    }

    iniRead, switchItemKeysDetached, %mCurrentIniFile%, Items, key_detached
    switchItemKeyArray := StrSplit(switchItemKeysDetached, ";")
    Loop %mNumItemHotkeys% {
        GuiControl, Choose, SwitchItemKeyDetached%A_Index%, % getValueIndexFromDict(single_keys_map, switchItemKeyArray[A_Index], 1)
    }

    iniRead, switchItemButton, %mCurrentIniFile%, Items, switch_item_button
    GuiControl, Choose, SwitchItemKey, % getValueIndexFromDict(all_keys_map, switchItemButton, 1)

    iniRead, itemNameRegion, %mCurrentIniFile%, Items, item_name_region
    if (!itemNameRegion) { ; 未设置分辨率，尝试从配置文件中寻找预设值
        itemNameRegion := findTextRegion(1)
    }
    GuiControl, Text, ItemNameRegion, % itemNameRegion
}

initEqp() {
    iniRead, equipmentRegion, %mCurrentIniFile%, Equipment, equipment_region
    if (!equipmentRegion) { ; 未设置分辨率，尝试从配置文件中寻找预设值
        equipmentRegion := findTextRegion(2)
    }
    GuiControl, Text, EquipmentRegion, % equipmentRegion

    Loop %mNumEqpHotKeys% {
        iniRead, config, %mCurrentIniFile%, Equipment, config%A_Index%
        configArray := StrSplit(config, ";")
        key := configArray[1]
        type := configArray[2]
        pos := configArray[3]

        GuiControl, Choose, EqpKey%A_Index%, % getValueIndexFromDict(single_keys_map, key, 1)
        GuiControl, Choose, EqpType%A_Index%, % getValueIndexFromDict(equipment_types, type, 1)
        GuiControl, Choose, EqpPos%A_Index%, % getValueIndexFromDict(equipment_positions, pos, 1)
    }
}

initKeyMap() {
    Loop %mNumKeyMaps% {
        iniRead, config, %mCurrentIniFile%, KeyMap, config%A_Index%
        configArray := StrSplit(config, ";")
        kmGameKey := configArray[1]
        kmNewKey := configArray[2]

        GuiControl, Choose, KmGameKey%A_Index%, % getValueIndexFromDict(all_keys_map, kmGameKey, 1)
        GuiControl, Choose, KmNewKey%A_Index%, % getValueIndexFromDict(all_keys_map, kmNewKey, 1)
    }
}

findTextRegion(type) {
    SysGet, ScreenDimen, Monitor
    width := ScreenDimenRight - ScreenDimenLeft
    height := ScreenDimenBottom - ScreenDimenTop
    if (type = 0) { ; 查找法术名称显示区域的预设值
        key = Spell_%width%_%height%
        iniRead, spellNameRegion, %mCurrentIniFile%, Resolution, %key%, 0;0;0;0
        return spellNameRegion
    } else if (type = 1) { ; 查找消耗品名称显示区域的预设值
        key = Item_%width%_%height%
        iniRead, itemNameRegion, %mCurrentIniFile%, Resolution, %key%, 0;0;0;0
        return itemNameRegion
    } else if (type = 2) { ; 查找装备显示区域的预设值
        key = Eqp_%width%_%height%
        iniRead, equipmentRegion, %mCurrentIniFile%, Resolution, %key%, 0;0;0;0
        return equipmentRegion
    }
}

saveHotkeySettings() {
	; 记录翻滚设置
	GuiControlGet, DodgingKeyInGame
	GuiControlGet, DodgingKeyDetached
	IniWrite, % all_keys_map.Item(DodgingKeyInGame), %mCurrentIniFile%, Dodging, key_in_game
	IniWrite, % all_keys_map.Item(DodgingKeyDetached), %mCurrentIniFile%, Dodging, key_detached

	; 记录切换间隔时间
	GuiControlGet, ClickInterval
	if (ClickInterval < 30) {
		ClickInterval = 30
	} else if (ClickInterval > 200) {
		ClickInterval = 200
	}
	IniWrite, %ClickInterval%, %mCurrentIniFile%, Common, click_interval

	; 记录菜单键和确认键
	GuiControlGet, MenuKeyInGame
	GuiControlGet, ConfirmKeyInGame
	IniWrite, % single_keys_map.Item(MenuKeyInGame), %mCurrentIniFile%, Common, menu_button
	IniWrite, % single_keys_map.Item(ConfirmKeyInGame), %mCurrentIniFile%, Common, confirm_button

	; 记录已记忆的法术
	EquippedSpellsString := ""
	Loop %mNumSpellHotkeys% {
	    GuiControlGet, EquippedSpell%A_Index%
		value := EquippedSpell%A_Index%
		if (!value) {
			continue
		}
		value := StrReplace(value, ";", "") ; ini中用分号将数组转换为字符串，所以需要去除分号
		if (A_Index != 1) {
			EquippedSpellsString .= ";"
		}
		EquippedSpellsString .= value
	}
	IniWrite, %EquippedSpellsString%, %mCurrentIniFile%, Spells, equipped_spells

	; 记录切换法术按键
	SwitchSpellKeysString := ""
	Loop %mNumSpellHotkeys% {
	    GuiControlGet, SwitchSpellKeyDetached%A_Index%
		value := SwitchSpellKeyDetached%A_Index%
		if (A_Index != 1) {
			SwitchSpellKeysString .= ";"
		}
		SwitchSpellKeysString .= all_keys_map.Item(value)
	}
	IniWrite, %SwitchSpellKeysString%, %mCurrentIniFile%, Spells, key_detached

	; 记录法术设置
	GuiControlGet, SwitchSpellKey
	GuiControlGet, SpellNameRegion
	IniWrite, % all_keys_map.Item(SwitchSpellKey), %mCurrentIniFile%, Spells, switch_spell_button
	IniWrite, %SpellNameRegion%, %mCurrentIniFile%, Spells, spell_name_region

	; 记录已装备的消耗品
	EquippedItemsString := ""
	Loop %mNumItemHotkeys% {
	    GuiControlGet, EquippedItem%A_Index%
		value := EquippedItem%A_Index%
		if (!value) {
			continue
		}
		value := StrReplace(value, ";", "") ; ini中用分号将数组转换为字符串，所以需要去除分号
		if (A_Index != 1) {
			EquippedItemsString .= ";"
		}
		EquippedItemsString .= value
	}
	IniWrite, %EquippedItemsString%, %mCurrentIniFile%, Items, equipped_items

	; 记录切换消耗品按键
	SwitchItemKeysString := ""
	Loop %mNumItemHotkeys% {
	    GuiControlGet, SwitchItemKeyDetached%A_Index%
		value := SwitchItemKeyDetached%A_Index%
		if (A_Index != 1) {
			SwitchItemKeysString .= ";"
		}
		SwitchItemKeysString .= all_keys_map.Item(value)
	}
	IniWrite, %SwitchItemKeysString%, %mCurrentIniFile%, Items, key_detached

	; 记录消耗品设置
	GuiControlGet, SwitchItemKey
	GuiControlGet, ItemNameRegion
	IniWrite, % all_keys_map.Item(SwitchItemKey), %mCurrentIniFile%, Items, switch_item_button
	IniWrite, %ItemNameRegion%, %mCurrentIniFile%, Items, item_name_region

	; 记录装备设置
	GuiControlGet, EquipmentRegion
	IniWrite, %EquipmentRegion%, %mCurrentIniFile%, Equipment, equipment_region
	Loop %mNumEqpHotKeys% {
	    GuiControlGet, EqpKey%A_Index%
		GuiControlGet, EqpType%A_Index%
		GuiControlGet, EqpPos%A_Index%
		eqpKey := single_keys_map.Item(EqpKey%A_Index%)
		eqpType := equipment_types.Item(EqpType%A_Index%)
		eqpPos := equipment_positions.Item(EqpPos%A_Index%)
		value := eqpKey . ";" . eqpType . ";" . eqpPos
	    IniWrite, %value%, %mCurrentIniFile%, Equipment, config%A_Index%
	}

	; 记录按键映射设置
	Loop %mNumKeyMaps% {
	    GuiControlGet, KmGameKey%A_Index%
		GuiControlGet, KmNewKey%A_Index%
		kmGameKey := all_keys_map.Item(KmGameKey%A_Index%)
		kmNewKey := all_keys_map.Item(KmNewKey%A_Index%)
		value := kmGameKey . ";" . kmNewKey
	    IniWrite, %value%, %mCurrentIniFile%, KeyMap, config%A_Index%
	}
}

OnERChecked:
    if (mCurrentCheckedGame != 1) {
        stopERA11y()
        saveHotkeySettings()

        mCurrentCheckedGame := 1
        mCurrentIniFile := "ER_A11y.ini"
        initUI()
    }
    return

OnDS3Checked:
    if (mCurrentCheckedGame != 2) {
        stopERA11y()
        saveHotkeySettings()

        mCurrentCheckedGame := 2
        mCurrentIniFile := "ER_A11y_DS3.ini"
        initUI()
    }
    return

ClearEqp:
    arr := StrSplit(A_GuiControl, "_")
    index := arr[2]
    if (index) {
        GuiControl, Choose, EqpKey%index%, 1
        GuiControl, Choose, EqpType%index%, 1
        GuiControl, Choose, EqpPos%index%, 1
    }
    return

ClearKeyMap:
    arr := StrSplit(A_GuiControl, "_")
    index := arr[2]
    if (index) {
        GuiControl, Choose, KmGameKey%index%, 1
        GuiControl, Choose, KmNewKey%index%, 1
    }
    return

EqpMeasureTipsClicked:
    Run res\\measure_equipment_region.jpg
    return

TextMeasureTipsClicked:
    Run res\\measure_text_region.jpg
    return

MyGithubClicked:
	Run https://github.com/ccr1sa/EldenRing_A11y
	return

PaddleGithubClicked:
	Run https://github.com/telppa/PaddleOCR-AutoHotkey
	return

OnBtnApplyClicked:
    if (mCurrentCheckedGame = 1) {
	    IniWrite, 1, ER_A11y.ini, Common, enabled
	    IniWrite, 0, ER_A11y_DS3.ini, Common, enabled
    } else {
	    IniWrite, 0, ER_A11y.ini, Common, enabled
	    IniWrite, 1, ER_A11y_DS3.ini, Common, enabled
    }
    saveHotkeySettings()
    startERA11y()
	return

GuiClose:
    stopERA11y()
    saveHotkeySettings()
	ExitApp