#SingleInstance Force
#NoTrayIcon

global gNumKeyMaps := 10

; 读取翻滚配置
iniRead, keyInGame, ER_A11y.ini, Dodging, key_in_game
global dodging_key_in_game := keyInGame
if (dodging_key_in_game) { ; 只有设置了游戏中的切换键，才能启用该功能
	iniRead, keyDetached, ER_A11y.ini, Dodging, key_detached
	if (keyDetached) {
		hotkey, ~%keyDetached%, newDodgeingKey
		hotkey, ~%dodging_key_in_game% & ~%keyDetached%, newDodgeingKey
	}
}

hotkeyWithDash(hotkey, callback) {
    ; 未设置翻滚键，不执行操作
    if (!dodging_key_in_game) {
        return
    }
    result = ~%dodging_key_in_game% & ~%hotkey%

    ; 对于小键盘的按键，当按住 Shift 时，将无法触发 ~LShift & ~Numpad1，而是触发 ~NumpadEnd
    if (%dodging_key_in_game% = LShift) or (%dodging_key_in_game% = RShift) {
        Switch hotkey
        {
            Case "NumpadDot": result = ~NumPadDel
            Case "Numpad0": result = ~NumpadIns
            Case "Numpad1": result = ~NumpadEnd
            Case "Numpad2": result = ~NumpadDown
            Case "Numpad3": result = ~NumpadPgDn
            Case "Numpad4": result = ~NumpadLeft
            Case "Numpad5": result = ~NumpadClear
            Case "Numpad6": result = ~NumpadRight
            Case "Numpad7": result = ~NumpadHome
            Case "Numpad8": result = ~NumpadUp
            Case "Numpad9": result = ~NumpadPgUp
            Default:
        }
    }
    hotkey, % result, % callback
}

; 读取法术配置
iniRead, equippedSpells, ER_A11y.ini, Spells, equipped_spells
global equipped_spells := StrSplit(equippedSpells, ";") ; 已装备的法术列表
iniRead, switchSpellButton, ER_A11y.ini, Spells, switch_spell_button
global switch_spell_button := switchSpellButton ; 切换法术的键盘按键。不能是大写字母，这会导致 AHK 按下 Shift 键
if (switch_spell_button) { ; 只有设置了游戏中的切换键，才能启用该功能
	iniRead, spellNameRegion, ER_A11y.ini, Spells, spell_name_region
	global spell_name_region := StrSplit(spellNameRegion, ";") ; 游戏中法术名称的像素区域
	iniRead, keyDetached1, ER_A11y.ini, Spells, key_detached
	global switchSpellKeys := StrSplit(keyDetached1, ";")
	for i, key in switchSpellKeys {
		if (key) {
	        funcSwitchSpell := Func("switchSpell").Bind(i)
			Hotkey, ~%key%, % funcSwitchSpell
		    hotkeyWithDash(key, funcSwitchSpell)
		}
	}
}

; 读取消耗品配置
iniRead, equippedItems, ER_A11y.ini, Items, equipped_items
global equipped_items := StrSplit(equippedItems, ";") ; 已装备的消耗品列表
iniRead, switchItemButton, ER_A11y.ini, Items, switch_item_button
global switch_item_button := switchItemButton ; 切换消耗品的键盘按键。不能是大写字母，这会导致 AHK 按下 Shift 键
if (switch_item_button) { ; 只有设置了游戏中的切换键，才能启用该功能
	iniRead, itemNameRegion, ER_A11y.ini, Items, item_name_region
	global item_name_region := StrSplit(itemNameRegion, ";") ; 游戏中消耗品名称的像素区域
	iniRead, keyDetached2, ER_A11y.ini, Items, key_detached
	global switchItemKeys := StrSplit(keyDetached2, ";")
	for i, key in switchItemKeys {
		if (key) {
	        funcSwitchItem := Func("switchItem").Bind(i)
			hotkey, ~%key%, % funcSwitchItem
		    hotkeyWithDash(key, funcSwitchItem)
		}
	}
}

; 读取通用配置
iniRead, clickInterval, ER_A11y.ini, Common, click_interval
global click_interval := clickInterval ; 切换法术或消耗品时，两次按键的间隔时间
iniRead, menuKeyInGame, ER_A11y.ini, Common, menu_button
global menu_button := menuKeyInGame
iniRead, confirmKeyInGame, ER_A11y.ini, Common, confirm_button
global confirm_button := confirmKeyInGame

; 读取装备配置
iniRead, equipmentRegion, ER_A11y.ini, Equipment, equipment_region
global equipment_dimen := StrSplit(equipmentRegion, ";") ; 游戏中显示装备的像素区域
global arsenal_dimen := []
arsenal_dimen.Push(equipment_dimen[1])
arsenal_dimen.Push(equipment_dimen[2])
arsenal_dimen.Push(equipment_dimen[3] * 0.915)
arsenal_dimen.Push(equipment_dimen[4] * 0.985)
; 计算装备的位置和尺寸
equipment_width := (equipment_dimen[3] - equipment_dimen[1]) / 5 ; 装备格子宽度
equipment_height := (equipment_dimen[4] - equipment_dimen[2]) / 6 ; 装备格子高度
equipment_dimen[1] += equipment_width / 2 ; 用第 1、2 个元素保存首个装备格子中心坐标
equipment_dimen[2] += equipment_height / 2 ; 用第 1、2 个元素保存首个装备格子中心坐标
equipment_dimen[3] := equipment_width ; 用第 3、4 个元素保存下个装备格子偏移量
equipment_dimen[4] := equipment_height ; 用第 3、4 个元素保存下个装备格子偏移量
; 计算库存的位置和尺寸
equipment_width := (arsenal_dimen[3] - arsenal_dimen[1]) / 5
equipment_height := (arsenal_dimen[4] - arsenal_dimen[2]) / 6
arsenal_dimen[1] += equipment_width / 2 ; 用第 1、2 个元素保存首个装备格子中心坐标
arsenal_dimen[2] += equipment_height / 2 ; 用第 1、2 个元素保存首个装备格子中心坐标
arsenal_dimen[3] := equipment_width ; 用第 3、4 个元素保存下个装备格子偏移量
arsenal_dimen[4] := equipment_height ; 用第 3、4 个元素保存下个装备格子偏移量

global eqp_types := []
global eqp_positions := []
if (menu_button) and (confirm_button) { ; 只有设置了游戏中的返回键和确认，才能启用该功能
    Loop 9 {
        iniRead, config, ER_A11y.ini, Equipment, config%A_Index%
        configArray := StrSplit(config, ";")
        key := configArray[1]
        eqp_types.Push(configArray[2])
        eqp_positions.Push(configArray[3])

        if (key) {
	        funcSwitchEqp := Func("switchEquippment").Bind(A_Index)
			hotkey, ~%key%, % funcSwitchEqp
		    hotkeyWithDash(key, funcSwitchEqp)
        }
    }
}

; 读取按键映射配置
global gKmGameKeys := []
Loop %gNumKeyMaps% {
    iniRead, config, ER_A11y.ini, KeyMap, config%A_Index%
    configArray := StrSplit(config, ";")
    gKmGameKeys.Push(configArray[1])
    kmNewKey := configArray[2]

    if (kmNewKey) {
    	funcSendMappedKey := Func("sendMappedKey").Bind(A_Index)
        hotkey, ~%kmNewKey%, % funcSendMappedKey
        hotkeyWithDash(kmNewKey, funcSendMappedKey)
    }
}

; 当匹配到多个可能的结果时，借助该变量可选取距离最近的结果
global spellCurrentIndex := 0
global itemCurrentIndex := 0
return

#Include PaddleOCR\PaddleOCR.ahk

recogText(l, t, r, b) {
    if (FileExist("Dll\\PaddleOCR.dll")) {
	    return PaddleOCR([l, t, r-l, b-t], {"use_mkldnn":1, "det_db_thresh": 0.3})
    }
    return ""
}

; 长按一个按键
longPress(button) {
    Send {Blind}{%button% down}
    Sleep 650
    Send {Blind}{%button% up}
}

; 单击或连击一个按键
singlePress(button, count:=1, interval:=-1) {
    if (interval < 0) {
        interval := click_interval
    }
    if (count = 1) {
		Send {Blind}{%button% down}
		Sleep 10
    	Send {Blind}{%button% up}
		Sleep % interval
    } else {
        Loop %count% {
            Send {Blind}{%button% down}
            Sleep 10
            Send {Blind}{%button% up}
            Sleep % interval
        }
	}
}

; 单击鼠标左键
LeftClick(x, y, interval:=-1) {
    if (interval < 0) {
        interval := click_interval
    }
    ;不使用普通的 Click 语句，否则有较低的几率会点击不生效
    Click, %x% %y% Down
    Sleep, 10
    Click, Up
    Sleep % interval
 }

; 使用指定长度和初始元素来创建数组
initialArray(len, initialElement) {
	result := []
	Loop %len% {
		result.Push(initialElement)
	}
	return result
}

; 判断一个数是否为奇数
isOdd(num) {
	return (num & 1)? 1: 0
}

; 生成特殊的索引数组，例如 num=3 时，返回 [0, 1, -1, 2, -2, 3, -3]
genSpreadIndexArray(num) {
	result := []
	result.Push(0)
	len := num * 2 + 1
	Loop %len%  {
		index := (A_Index + 1) // 2
		if (!isOdd(A_Index)) {
			index *= -1
		}
		result.Push(index)
	}
	return result
}

; 从 array 数组中寻找值最大的元素的索引
findMaxValueIndex(array, indexArray) {
	maxValueIndex := 0
	maxValue := -2147483648

	if (indexArray) {
		len := array.MaxIndex()
		for i, index in indexArray {
		    if (index < 1) or (index > len) {
		    	continue
		    }

	    	value := array[index]
	    	if (maxValue < value) {
	    		maxValue := value
	    		maxValueIndex := index
	    	}
		}
	} else {
		for i, value in array {
	    	if (maxValue < value) {
	    		maxValue := value
	    		maxValueIndex := i
	    	}
		}
	}
	return maxValueIndex
}

calStringArrayMatchingScore(target, stringArray) {
	hasMatching := 0
	matchingScore := 
	if (target) {
		matchingScore := initialArray(stringArray.MaxIndex(), 0)
		for i, string in stringArray {
			chars := StrSplit(string, "")
			for j, char in chars {
			    if (char = " ") {
			    	continue
			    }
				IfInString, target, %char%
				{
					matchingScore[i] += 1
					hasMatching := 1
				}
			}
		}
	}
	return hasMatching? matchingScore: 
}

getCircularSwitchTimes(currentIndex, targetIndex, maxIndex) {
	pressTimes := 0
	if (currentIndex < targetIndex) {
		pressTimes := targetIndex - currentIndex
	} else if (currentIndex > targetIndex) {
		pressTimes := maxIndex - currentIndex + targetIndex
	}
	return pressTimes
}

realSwitchSpell(targetIndex, longPressWhenUnmatched) {
	numSpells := equipped_spells.MaxIndex()
	if (targetIndex > numSpells) {
		return
	}

	currentSpellName := recogText(spell_name_region[1], spell_name_region[2], spell_name_region[3], spell_name_region[4])
	matchingScore := calStringArrayMatchingScore(currentSpellName, equipped_spells)

	if (matchingScore) {
		indexArr := genSpreadIndexArray(numSpells)
		for i, index in indexArr {
			indexArr[i] += spellCurrentIndex
		}
		maxScoreIndex := findMaxValueIndex(matchingScore, indexArr)
		pressTimes := getCircularSwitchTimes(maxScoreIndex, targetIndex, numSpells)
		singlePress(switch_spell_button, pressTimes)
	}
	 else if (longPressWhenUnmatched) {
		longPress(switch_spell_button)
		Sleep, % click_interval
		singlePress(switch_spell_button, targetIndex - 1)
	}

	spellCurrentIndex := targetIndex
}

realSwitchItem(targetIndex, longPressWhenUnmatched) {
	numItems := equipped_items.MaxIndex()
	if (targetIndex > numItems) {
		return
	}

	currentItemName := recogText(item_name_region[1], item_name_region[2], item_name_region[3], item_name_region[4])
	matchingScore := calStringArrayMatchingScore(currentItemName, equipped_items)

	if (matchingScore) {
		indexArr := genSpreadIndexArray(numItems)
		for i, index in indexArr {
			indexArr[i] += itemCurrentIndex
		}
		maxScoreIndex := findMaxValueIndex(matchingScore, indexArr)
		pressTimes := getCircularSwitchTimes(maxScoreIndex, targetIndex, numItems)
		singlePress(switch_item_button, pressTimes)
	}
	 else if (longPressWhenUnmatched) {
		longPress(switch_item_button)
		Sleep, % click_interval
		singlePress(switch_item_button, targetIndex - 1)
	}

	itemCurrentIndex := targetIndex
}

checkEldenRingWindow() {
	WinGetActiveTitle, Title
	window := "ELDEN RING"
	IfInString, Title, %window%
	{
		return 1
	}
	return 0
}

; 按键切换法术
switchSpell(targetIndex) {
	if (checkEldenRingWindow() = 0) {
		return
	}
	realSwitchSpell(targetIndex, true)
	Sleep % click_interval
	realSwitchSpell(targetIndex, false)
}

; 按键切换消耗品
switchItem(targetIndex) {
	if (checkEldenRingWindow() = 0) {
		return
	}
	realSwitchItem(targetIndex, true)
	Sleep % click_interval
	realSwitchItem(targetIndex, false)
}

; 按键切换装备
switchEquippment(index) {
	if (checkEldenRingWindow() = 0) {
		return
	}
	type := eqp_types[index]
    typeArr := StrSplit(type, "_")
	pos := eqp_positions[index]
    posArr := StrSplit(pos, "_")
    long_interval := click_interval * 2

    singlePress(menu_button, 1)
    Sleep, % long_interval
    singlePress(confirm_button, 1)
    Sleep, % long_interval

    LeftClick(equipment_dimen[1] + (equipment_dimen[3] * typeArr[1]), equipment_dimen[2] + (equipment_dimen[4] * typeArr[2]), long_interval)
    LeftClick(arsenal_dimen[1] + (arsenal_dimen[3] * posArr[1]), arsenal_dimen[2] + (arsenal_dimen[4] * posArr[2]), long_interval)

    singlePress(menu_button, 1)
}

; 按键映射
sendMappedKey(index) {
	if (checkEldenRingWindow() = 0) {
		return
	}
    kmGameKey := gKmGameKeys[index]
    if (kmGameKey) {
        singlePress(kmGameKey, 1)
    }
}

; 翻滚与奔跑分离
newDodgeingKey:
	if (checkEldenRingWindow() = 0) {
		return
	}
	Loop 3 {
		Send {Blind}{%dodging_key_in_game% up}
		Send {Blind}{%dodging_key_in_game% down}
	}

    DashStateFeature = ~%dodging_key_in_game% &
	IfNotInString, A_ThisHotkey, %DashStateFeature%
	{
	    Send {Blind}{%dodging_key_in_game% up}
	}
	Sleep 150
	return