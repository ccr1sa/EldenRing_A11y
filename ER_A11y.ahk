#SingleInstance Force
#NoTrayIcon

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
			labelName := "switchSpellKey" + i
			hotkey, ~%key%, %labelName%
			hotkey, ~%dodging_key_in_game% & ~%key%, %labelName%
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
			labelName := "switchItemKey" + i
			hotkey, ~%key%, %labelName%
			hotkey, ~%dodging_key_in_game% & ~%key%, %labelName%
		}
	}
}

; 读取通用配置
iniRead, clickInterval, ER_A11y.ini, Common, click_interval
global click_interval := clickInterval ; 切换法术或消耗品时，两次按键的间隔时间

; 当匹配到多个可能的结果时，借助该变量可选取距离最近的结果
global spellCurrentIndex := 0
global itemCurrentIndex := 0
return

#Include PaddleOCR\PaddleOCR.ahk

recogText(l, t, r, b) {
	return PaddleOCR([l, t, r-l, b-t], {"use_mkldnn":1, "det_db_thresh": 0.3})
}

; 长按一个按键
longPress(button) {
    Send {%button% Down}
    Sleep 650
    Send {%button% Up}
}

; 单击或连击一个按键
singlePress(button, count:=1, interval:=-1) {
    if (interval < 0) {
        interval := click_interval
    }
    if (count = 1) {
		Send {%button% Down}e
		Sleep 10
    	Send {%Button% Up}
		Sleep % interval
    } else {
        Loop %count% {
            Send {%button% Down}
            Sleep 10
            Send {%Button% Up}
            Sleep % interval
        }
	}
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

	spellCurrentIndex := targetIndex
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

switchSpellKey1:
	switchSpell(1)
	return

switchSpellKey2:
	switchSpell(2)
	return

switchSpellKey3:
	switchSpell(3)
	return

switchSpellKey4:
	switchSpell(4)
	return

switchSpellKey5:
	switchSpell(5)
	return

switchSpellKey6:
	switchSpell(6)
	return

switchSpellKey7:
	switchSpell(7)
	return

switchSpellKey8:
	switchSpell(8)
	return

switchSpellKey9:
	switchSpell(9)
	return

switchSpellKey10:
	switchSpell(10)
	return


; 按键切换消耗品
switchItem(targetIndex) {
	if (checkEldenRingWindow() = 0) {
		return
	}
	realSwitchItem(targetIndex, true)
	Sleep % click_interval
	realSwitchItem(targetIndex, false)
}

switchItemKey1:
	switchItem(1)
	return

switchItemKey2:
	switchItem(2)
	return

switchItemKey3:
	switchItem(3)
	return

switchItemKey4:
	switchItem(4)
	return

switchItemKey5:
	switchItem(5)
	return

switchItemKey6:
	switchItem(6)
	return

switchItemKey7:
	switchItem(7)
	return

switchItemKey8:
	switchItem(8)
	return

switchItemKey9:
	switchItem(9)
	return

switchItemKey10:
	switchItem(10)
	return


; 翻滚与奔跑分离
newDodgeingKey:
	if (checkEldenRingWindow() = 0) {
		return
	}
	Loop 4 {
		Send {%dodging_key_in_game% up}
		Send {%dodging_key_in_game% down}
	}
	Send {%dodging_key_in_game% up}
	Sleep 150
	return