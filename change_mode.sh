#!/bin/bash

# Получаем текущий статус
output=$(asusctl fan-curve -m balanced)

# Ищем строку с параметрами pwm для CPU
cpu_pwm=$(echo "$output" | grep -A 7 'fan = "CPU"' | grep 'pwm' | awk -F'= ' '{print $2}' | head -n 1)

# Выводим значение для диагностики
echo "pwm: $cpu_pwm"

# Проверяем условия и применяем нужную группу команд
if [[ "$cpu_pwm" == "[0, 3, 13, 26, 102, 153, 255, 255]" ]]; then
    # Применяем cooling
    asusctl fan-curve -m balanced -D 30c:95%,40c:95%,50c:95%,60c:95%,70c:95%,80c:95%,90c:95%,100c:95% -f cpu
    asusctl fan-curve -m balanced -D 30c:95%,40c:95%,50c:95%,60c:95%,70c:95%,80c:95%,90c:95%,100c:95% -f gpu
    asusctl fan-curve -m balanced -e true
    echo "cooling"
    kdialog --title "Fan Curve" --passivepopup "Cooling mode" 3kdialog --icon "utilities-terminal" --passivepopup "Cooling mode" 3
else
    # Применяем normal
    asusctl fan-curve -m balanced -D 30c:0%,40c:1%,50c:5%,60c:10%,70c:40%,80c:60%,90c:100%,100c:100% -f cpu
    asusctl fan-curve -m balanced -D 30c:0%,40c:1%,50c:5%,60c:10%,70c:40%,80c:60%,90c:100%,100c:100% -f gpu
    asusctl fan-curve -m balanced -e true
    echo "normal"
    kdialog --title "Fan Curve" --passivepopup "Normal mode" 3kdialog --icon "utilities-terminal" --passivepopup "Normal mode" 3
fi

