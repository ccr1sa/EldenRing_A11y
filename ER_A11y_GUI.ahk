#SingleInstance Force
#NoTrayIcon

genListBoxParamFromDict(useK1orV0, dict) {
	tmp := "|"
	for k in dict {
		append := useK1orV0? k: dict.Item(k)
		tmp .= append
		tmp .= "|"
	}
	return tmp
}

setListBoxParamSelection(listBoxParam, selection) {
	v1 := "|" . selection . "|"
	v2 := "|" . selection . "||"
	listBoxParam := StrReplace(listBoxParam, v1, v2)
	return listBoxParam
}

findKeyFromDict(dict, value) {
	for k in dict {
		v := dict.Item(k)
		if (value = v) {
			return k
		}
	}
}

addTitle(title, yOffset) {
    Gui, font, s10 bold
    Gui, Add, Text, xm+10 y+%yOffset% h18 0x200, % title
    Gui, font
}

findTextRegion(type) {
    SysGet, ScreenDimen, Monitor
    width := ScreenDimenRight - ScreenDimenLeft
    height := ScreenDimenBottom - ScreenDimenTop
    if (type = 0) { ; 查找法术名称显示区域的预设值
        key = Spell_%width%_%height%
        iniRead, spellNameRegion, ER_A11y.ini, Resolution, %key%, 0;0;0;0
        return spellNameRegion
    } else if (type = 1) { ; 查找消耗品名称显示区域的预设值
        key = Item_%width%_%height%
        iniRead, itemNameRegion, ER_A11y.ini, Resolution, %key%, 0;0;0;0
        return itemNameRegion
    }
}

; 初始化可选按键的配置
combine_keys_map := ComObjCreate("Scripting.Dictionary")
combine_keys_map.Add("空格", "Space")
combine_keys_map.Add("左 Control", "LCtrl")
combine_keys_map.Add("右 Control", "RCtrl")
combine_keys_map.Add("左 Shift", "LShift")
combine_keys_map.Add("右 Shift", "RShift")
combine_keys_map.Add("左 Alt", "LAlt")
combine_keys_map.Add("右 Alt", "RAlt")
combine_keys_list_box_value := genListBoxParamFromDict(1, combine_keys_map)

single_keys_map := ComObjCreate("Scripting.Dictionary")
single_keys_map.Add("Esc", "Esc")
single_keys_map.Add("Tab", "Tab")
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

all_keys_map := ComObjCreate("Scripting.Dictionary")
for k in combine_keys_map
	all_keys_map.Add(k, combine_keys_map.Item(k))
for k in single_keys_map
	all_keys_map.Add(k, single_keys_map.Item(k))
StringTrimRight, temp, combine_keys_list_box_value, 1 ; 去除最后的 | 符号
all_keys_list_box_value := temp . single_keys_list_box_value


; 创建 GUI
Gui, Add, Tab3, w456 h320, 常规|法术|消耗品|说明

Gui, Tab, 
Gui, Add, Button, Default w80 xm+188 y+4 gOnBtnApplyClicked, 应用


; 翻滚设置
Gui, Tab, 1

iniRead, dodgingKeyInGame, ER_A11y.ini, Dodging, key_in_game
selection := findKeyFromDict(all_keys_map, dodgingKeyInGame)
temp := setListBoxParamSelection(all_keys_list_box_value, selection)
addTitle("分离奔跑和翻滚按键", 10)
Gui, Add, Text, xm+16 y+8 h18 0x200, 游戏的翻滚键
Gui, Add, DropDownList, x+8 vDodgingKeyInGame, %temp%

iniRead, dodgingKeyDetached, ER_A11y.ini, Dodging, key_detached
selection := findKeyFromDict(all_keys_map, dodgingKeyDetached)
temp := setListBoxParamSelection(all_keys_list_box_value, selection)
Gui, Add, Text, x+8 h18 0x200, 新的翻滚键
Gui, Add, DropDownList, x+8 vDodgingKeyDetached, %temp%
Gui, Add, Text, xm+16 y+8, 　　游戏的翻滚操作是在按下并松开翻滚键后触发的，如果松开较慢，则会出`n现翻滚延迟。这里可以设置一个新的翻滚键，当按下它时，会立刻发送按下翻`n滚键和松开翻滚键2个操作，实现在按下时触发翻滚。

Gui, Add, Text, xm+16 y+16 w420 0x10  ;Horizontal Line > Black


; 通用设置
addTitle("通用", 0)
iniRead, menuKeyInGame, ER_A11y.ini, Common, menu_button
selection := findKeyFromDict(single_keys_map, menuKeyInGame)
temp := setListBoxParamSelection(single_keys_list_box_value, selection)
Gui, Add, Text, xm+16 y+8 h18 0x200, 游戏的菜单键
Gui, Add, DropDownList, x+8 vMenuKeyInGame, %temp%
iniRead, confirmKeyInGame, ER_A11y.ini, Common, confirm_button
selection := findKeyFromDict(single_keys_map, confirmKeyInGame)
temp := setListBoxParamSelection(single_keys_list_box_value, selection)
Gui, Add, Text, xm+16 y+8 h18 0x200, 游戏的确认键
Gui, Add, DropDownList, x+8 vConfirmKeyInGame, %temp%

iniRead, clickInterval, ER_A11y.ini, Common, click_interval
Gui, Add, Text, xm+16 y+8 h18 0x200, 切换法术和消耗品的间隔时间
Gui, Add, Edit, r1 vClickInterval x+8 w135 Number, %clickInterval%
Gui, Add, Text, xm+16 y+8, 　　切换法术和消耗品时，两次切换操作的间隔时间(毫秒)。数值越低，切换`n速度越快，但可能因为游戏掉帧而导致一些切换操作被忽略，出现切换错误的`n情况。至少设置为 30 以上。


; 法术设置
Gui, Tab, 2

Gui, Add, Text, xm+10 y+8 h18 0x200, 为每一个法术设置单独的选择按键
iniRead, equippedSpells, ER_A11y.ini, Spells, equipped_spells
equippedSpellArray := StrSplit(equippedSpells, ";")
Gui, Add, Edit, r1 vEquippedSpell1 xm+10 y+8 w80, % equippedSpellArray[1] 
Gui, Add, Edit, r1 vEquippedSpell2 x+8 w80, % equippedSpellArray[2] 
Gui, Add, Edit, r1 vEquippedSpell3 x+8 w80, % equippedSpellArray[3] 
Gui, Add, Edit, r1 vEquippedSpell4 x+8 w80, % equippedSpellArray[4] 
Gui, Add, Edit, r1 vEquippedSpell5 x+8 w80, % equippedSpellArray[5] 
Gui, Add, Edit, r1 vEquippedSpell6 xm+10 y+4 w80, % equippedSpellArray[6] 
Gui, Add, Edit, r1 vEquippedSpell7 x+8 w80, % equippedSpellArray[7] 
Gui, Add, Edit, r1 vEquippedSpell8 x+8 w80, % equippedSpellArray[8] 
Gui, Add, Edit, r1 vEquippedSpell9 x+8 w80, % equippedSpellArray[9] 
Gui, Add, Edit, r1 vEquippedSpell10 x+8 w80, % equippedSpellArray[10] 

Gui, Add, Text, xm+10 y+10 h18 0x200, ↑填写你记忆的法术　　　　　　　　　　　　　　　　　设置各个法术的按键↓
iniRead, switchSpellKeysDetached, ER_A11y.ini, Spells, key_detached
switchSpellKeyArray := StrSplit(switchSpellKeysDetached, ";")
tempArr := []
Loop 10 {
	selection := findKeyFromDict(single_keys_map, switchSpellKeyArray[A_Index])
	temp := setListBoxParamSelection(single_keys_list_box_value, selection)
	tempArr.Push(temp)
}
Gui, Add, DropDownList, xm+10 y+8 w80 vSwitchSpellKeyDetached1, % tempArr[1]
Gui, Add, DropDownList, x+8 w80 vSwitchSpellKeyDetached2, % tempArr[2]
Gui, Add, DropDownList, x+8 w80 vSwitchSpellKeyDetached3, % tempArr[3]
Gui, Add, DropDownList, x+8 w80 vSwitchSpellKeyDetached4, % tempArr[4]
Gui, Add, DropDownList, x+8 w80 vSwitchSpellKeyDetached5, % tempArr[5]
Gui, Add, DropDownList, xm+10 y+4 w80 vSwitchSpellKeyDetached6, % tempArr[6]
Gui, Add, DropDownList, x+8 w80 vSwitchSpellKeyDetached7, % tempArr[7]
Gui, Add, DropDownList, x+8 w80 vSwitchSpellKeyDetached8, % tempArr[8]
Gui, Add, DropDownList, x+8 w80 vSwitchSpellKeyDetached9, % tempArr[9]
Gui, Add, DropDownList, x+8 w80 vSwitchSpellKeyDetached10, % tempArr[10]

iniRead, switchSpellButton, ER_A11y.ini, Spells, switch_spell_button
selection := findKeyFromDict(all_keys_map, switchSpellButton)
temp := setListBoxParamSelection(all_keys_list_box_value, selection)
Gui, Add, Text, xm+10 y+8 h18 0x200, 游戏的切换法术键　
Gui, Add, DropDownList, x+8 vSwitchSpellKey, %temp%

iniRead, spellNameRegion, ER_A11y.ini, Spells, spell_name_region
if (!spellNameRegion) { ; 未设置分辨率，尝试从配置文件中寻找预设值
    spellNameRegion := findTextRegion(0)
}
Gui, Add, Text, xm+10 y+8 h18 0x200, 名称显示区域　　　
Gui, Add, Edit, r1 vSpellNameRegion x+8 w135, %spellNameRegion%
Gui, Add, Text, cRed, 如果设置不正确，程序将总是通过长按切换键来切换。
Gui, Add, Text, y+0, 如果你遇到上述问题，请使用PS、截图等工具测量该值。
Gui, Add, Text, y+0, 要了解测量方法，请查看
Gui, Add, Text, x+0 cBlue gTextMeasureTipsClicked, 显示区域测量


; 消耗品设置
Gui, Tab, 3

Gui, Add, Text, xm+10 y+8 h18 0x200, 为每一个消耗品设置单独的选择按键
iniRead, equippedItems, ER_A11y.ini, Items, equipped_items
equippedItemArray := StrSplit(equippedItems, ";")
Gui, Add, Edit, r1 vEquippedItem1 xm+10 y+8 w80, % equippedItemArray[1] 
Gui, Add, Edit, r1 vEquippedItem2 x+8 w80, % equippedItemArray[2] 
Gui, Add, Edit, r1 vEquippedItem3 x+8 w80, % equippedItemArray[3] 
Gui, Add, Edit, r1 vEquippedItem4 x+8 w80, % equippedItemArray[4] 
Gui, Add, Edit, r1 vEquippedItem5 x+8 w80, % equippedItemArray[5] 
Gui, Add, Edit, r1 vEquippedItem6 xm+10 y+4 w80, % equippedItemArray[6] 
Gui, Add, Edit, r1 vEquippedItem7 x+8 w80, % equippedItemArray[7] 
Gui, Add, Edit, r1 vEquippedItem8 x+8 w80, % equippedItemArray[8] 
Gui, Add, Edit, r1 vEquippedItem9 x+8 w80, % equippedItemArray[9] 
Gui, Add, Edit, r1 vEquippedItem10 x+8 w80, % equippedItemArray[10] 

Gui, Add, Text, xm+10 y+10 h18 0x200, ↑填写你携带的消耗品　　　　　　　　　　　　　　　设置各个消耗品的按键↓
iniRead, switchItemKeysDetached, ER_A11y.ini, Items, key_detached
switchItemKeyArray := StrSplit(switchItemKeysDetached, ";")
tempArr := []
Loop 10 {
	selection := findKeyFromDict(single_keys_map, switchItemKeyArray[A_Index])
	temp := setListBoxParamSelection(single_keys_list_box_value, selection)
	tempArr.Push(temp)
}
Gui, Add, DropDownList, xm+10 y+8 w80 vSwitchItemKeyDetached1, % tempArr[1]
Gui, Add, DropDownList, x+8 w80 vSwitchItemKeyDetached2, % tempArr[2]
Gui, Add, DropDownList, x+8 w80 vSwitchItemKeyDetached3, % tempArr[3]
Gui, Add, DropDownList, x+8 w80 vSwitchItemKeyDetached4, % tempArr[4]
Gui, Add, DropDownList, x+8 w80 vSwitchItemKeyDetached5, % tempArr[5]
Gui, Add, DropDownList, xm+10 y+4 w80 vSwitchItemKeyDetached6, % tempArr[6]
Gui, Add, DropDownList, x+8 w80 vSwitchItemKeyDetached7, % tempArr[7]
Gui, Add, DropDownList, x+8 w80 vSwitchItemKeyDetached8, % tempArr[8]
Gui, Add, DropDownList, x+8 w80 vSwitchItemKeyDetached9, % tempArr[9]
Gui, Add, DropDownList, x+8 w80 vSwitchItemKeyDetached10, % tempArr[10]

iniRead, switchItemButton, ER_A11y.ini, Items, switch_item_button
selection := findKeyFromDict(all_keys_map, switchItemButton)
temp := setListBoxParamSelection(all_keys_list_box_value, selection)
Gui, Add, Text, xm+10 y+8 h18 0x200, 游戏的切换消耗品键
Gui, Add, DropDownList, x+8 vSwitchItemKey, %temp%

iniRead, itemNameRegion, ER_A11y.ini, Items, item_name_region
if (!itemNameRegion) { ; 未设置分辨率，尝试从配置文件中寻找预设值
    itemNameRegion := findTextRegion(1)
}
Gui, Add, Text, xm+10 y+8 h18 0x200, 名称显示区域　　　
Gui, Add, Edit, r1 vItemNameRegion x+8 w135, %itemNameRegion%
Gui, Add, Text, cRed, 如果设置不正确，程序将总是通过长按切换键来切换。
Gui, Add, Text, y+0, 如果你遇到上述问题，请使用PS、截图等工具测量该值。
Gui, Add, Text, y+0, 要了解测量方法，请查看
Gui, Add, Text, x+0 cBlue gTextMeasureTipsClicked, 显示区域测量


; 武器设置
Gui, Tab, 4


; 说明
Gui, Tab, 4
Gui, Add, Text, xm+10 y+8 h18 0x200, 注意：　
Gui, Add, Text, y+8, 1. 程序使用屏幕文字识别和发送按键操作实现，与游戏进程无任何关联。`n`n2. 当法术或消耗品的名称与背景的颜色区别不大时 (例如，在化圣雪原里)，`n   文字识别可能失败，造成切换变慢或者错误。`n`n3. 未识别到文字时，将长按切换键回到第一项，然后再切换到指定项(较慢)。`n`n4. 文字识别使用 CPU 计算，在低性能 CPU 上可能识别较慢。`n   测试使用的是 i7-11800H，可瞬间响应。`n`n5. 切换法术和消耗品功能很可能不兼容英文游戏界面 (未测试)

Gui, Add, Text, xm+10 y+16 h18 0x200, 其他：　
Gui, Add, Text, y+8, 1. 这是一个开源项目
Gui, Add, Text, y+0 cBlue gMyGithubClicked, 　 https://github.com/ccr1sa/EldenRing_A11y
Gui, Add, Text, y+10, 2. 体积高达 380M 的原因是使用了光学字符识别库 PaddleOCR
Gui, Add, Text, y+0 cBlue gPaddleGithubClicked, 　 https://github.com/telppa/PaddleOCR-AutoHotkey

Gui Show, w480 h360, EldenRing Accessibility
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
	; 记录翻滚设置
	GuiControlGet, DodgingKeyInGame
	GuiControlGet, DodgingKeyDetached
	IniWrite, % all_keys_map.Item(DodgingKeyInGame), ER_A11y.ini, Dodging, key_in_game
	IniWrite, % all_keys_map.Item(DodgingKeyDetached), ER_A11y.ini, Dodging, key_detached

	; 记录切换间隔时间
	GuiControlGet, ClickInterval
	if (ClickInterval < 30) {
		ClickInterval = 30
	} else if (ClickInterval > 200) {
		ClickInterval = 200
	}
	IniWrite, %ClickInterval%, ER_A11y.ini, Common, click_interval

	; 记录菜单键和确认键
	GuiControlGet, MenuKeyInGame
	GuiControlGet, ConfirmKeyInGame
	IniWrite, % single_keys_map.Item(MenuKeyInGame), ER_A11y.ini, Common, menu_button
	IniWrite, % single_keys_map.Item(ConfirmKeyInGame), ER_A11y.ini, Common, confirm_button

	; 记录已记忆的法术
	EquippedSpellsString := ""
	Loop 10 {
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
	IniWrite, %EquippedSpellsString%, ER_A11y.ini, Spells, equipped_spells

	; 记录切换法术按键
	SwitchSpellKeysString := ""
	Loop 10 {
	    GuiControlGet, SwitchSpellKeyDetached%A_Index%
		value := SwitchSpellKeyDetached%A_Index%
		if (A_Index != 1) {
			SwitchSpellKeysString .= ";"
		}
		SwitchSpellKeysString .= all_keys_map.Item(value)
	}
	IniWrite, %SwitchSpellKeysString%, ER_A11y.ini, Spells, key_detached

	; 记录法术设置
	GuiControlGet, SwitchSpellKey
	GuiControlGet, SpellNameRegion
	IniWrite, % all_keys_map.Item(SwitchSpellKey), ER_A11y.ini, Spells, switch_spell_button
	IniWrite, %SpellNameRegion%, ER_A11y.ini, Spells, spell_name_region

	; 记录已装备的消耗品
	EquippedItemsString := ""
	Loop 10 {
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
	IniWrite, %EquippedItemsString%, ER_A11y.ini, Items, equipped_items

	; 记录切换消耗品按键
	SwitchItemKeysString := ""
	Loop 10 {
	    GuiControlGet, SwitchItemKeyDetached%A_Index%
		value := SwitchItemKeyDetached%A_Index%
		if (A_Index != 1) {
			SwitchItemKeysString .= ";"
		}
		SwitchItemKeysString .= all_keys_map.Item(value)
	}
	IniWrite, %SwitchItemKeysString%, ER_A11y.ini, Items, key_detached

	; 记录消耗品设置
	GuiControlGet, SwitchItemKey
	GuiControlGet, ItemNameRegion
	IniWrite, % all_keys_map.Item(SwitchItemKey), ER_A11y.ini, Items, switch_item_button
	IniWrite, %ItemNameRegion%, ER_A11y.ini, Items, item_name_region

	Run ER_A11y.ahk,,, PID
	return

GuiClose:
	Process, close, %PID%
	ExitApp