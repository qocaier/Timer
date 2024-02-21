<p align="right">[EN VERSION](README_EN.md)</p>

# Таймер
Это таймер отложенной 3д печати. Код, представленный в данном репозитории, создавался изначально для Creality K1 / K1 Max / K1C, но может подойдет и для других принтеров на Klipper
## Для чего он нужен?
В качестве основного сценария использования рассматривалась печать ночью[^1]. Хотелось, чтобы принтер, когда я заснул, сам включался и начинал печатать.

Думаю, таймер многим пригодится, особенно при длительной печати. С помощью него можно увеличить производительность вашего принтера, ведь ночь занимает немалую часть суток, которую лучше использовать с пользой
## Преимущества

## Инструкция
### Установка
1. Откройте *файлы конфигурации* принтера во Fluidd или другом веб-интерфейсе
2. Среди них есть *printer.cfg*, откройте его и добавьте следующие строки: в начало `[include Timer-Script/timer.cfg]`, в конец `[respond]`
3. Откройте *ssh терминал* принтера в Putty или другом клиенте
4. Отправьте следующие команды:
### Использование
1. Откройте *панель управления* принтера во Fluidd или другом веб-интерфейсе
2. В разделе с макросами найдите TIMER и откройте его выпадающее меню

<p align="center">![Картинка для открытия](macro_on.png)</p>

3. Введите параметры таймера, где HOURS - часы, MINUTES - минуты, IS_DURATION - является ли продолжительностью [0/1]. Да, таймер можно ставить как на промежуток (через X времени включится), так и на определенное время (в X)
> При выборе IS_DURATION=0 произойдет перезагрузка прошивки, и только потом поставится таймер. Не пугайтесь, эта необходимость связана с тем, что в Klipper неоткуда взять текущее время, необходимое для расчетов. Поэтому пришлось ~~создавать костыль~~ изобретать велосипед с запуском shell-скрипта и сохранением его результата в конфиг, а также последующей перезагрузкой, так как ~~этот долбанный~~ клиппер обновляет конфиги (и переменные, записанные в нем) только при перезапуске. По-другому не знал как поступить 🤷‍♂️

> По умолчанию, если запустить макрос с 0 в HOURS и MINUTES, таймер установится на 1 час, а будет это промежутком или нет - зависит от IS_DURATION

> [!CAUTION]
> При вводе некорректных значений таймер не запустится и выведет ошибку в консоль
## Отдельное спасибо
Tom Tomich

[^1]: Печать в ночное время может быть небезопасной. За любой ущерб, причиненный при установке или использовании таймера, автор ответственности не несет
