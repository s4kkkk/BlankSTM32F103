# исходники 
SRCS = src/main.cpp 
# путь к модулю STMCube (скачать на гитхабе stm)
STMCUBE_MODULE_PATH = /usr/arm-none-eabi/STM32CubeF1
# общие параметры компиляциии
CPPFLAGS = -gdwarf-4 -g3 -std=c++17 -Wall -mcpu=cortex-m3 -DSTM32F103xB -fno-exceptions -nostartfiles
# параметры компиляции startup-кода и реализации системных вызовов для NewLib
CFLAGS = -gdwarf-4 -g3 -std=c17 -Wall -mcpu=cortex-m3 -DSTM32F103xB
# целевая система команд; связано с адром процессора (например, для cortex-m3 - v7-m).
# реализации NewLib для различных систем команд, вероятно, будут расположены в /usr/arm-none-eabi/lib/thumb
TARGET_INSTRUCTION_SET = v7-m

.PHONY: upload clean

upload: binary/firmware.bin
	st-flash write binary/firmware.bin 0x8000000

clean:
	rm elfs/firmware.elf startup/startup.o binary/firmware.bin

binary/firmware.bin: elfs/firmware.elf
	mkdir -p binary
	arm-none-eabi-objcopy -O binary elfs/firmware.elf binary/firmware.bin objs/syscalls_impl.o

elfs/firmware.elf: startup/startup.o objs/syscalls_impl.o $(SRCS)
	mkdir -p elfs
	arm-none-eabi-g++ -Tstartup/LinkerScript.ld -o elfs/firmware.elf \
	-L/usr/lib/gcc/arm-none-eabi/$$(arm-none-eabi-g++ -dumpversion)/thumb/$(TARGET_INSTRUCTION_SET)/nofp \
	-L/usr/arm-none-eabi/lib/thumb/$(TARGET_INSTRUCTION_SET)/nofp \
	-I$(STMCUBE_MODULE_PATH)/Drivers/CMSIS/Core/Include  \
	-I$(STMCUBE_MODULE_PATH)/Drivers/CMSIS/Device/ST/STM32F1xx/Include  \
	$(CPPFLAGS) $(SRCS) \
	objs/syscalls_impl.o startup/startup.o


#--------------------------------------startup-код------------------------------------------#

startup/startup.o: startup/startup.cpp
	mkdir -p startup
	arm-none-eabi-g++ \
	-I$(STMCUBE_MODULE_PATH)/Drivers/CMSIS/Core/Include \
	-I$(STMCUBE_MODULE_PATH)/Drivers/CMSIS/Device/ST/STM32F1xx/Include \
	$(CPPFLAGS) -c startup/startup.cpp -o startup/startup.o

#-------------------------------------------------------------------------------------------#

#--------------------------------------Реализация SysCalls----------------------------------#

objs/syscalls_impl.o: src/syscalls_impl.c
	mkdir -p objs
	arm-none-eabi-gcc \
	-I$(STMCUBE_MODULE_PATH)/Drivers/CMSIS/Core/Include \
	-I$(STMCUBE_MODULE_PATH)/Drivers/CMSIS/Device/ST/STM32F1xx/Include \
	$(CFLAGS) -c src/syscalls_impl.c -o objs/syscalls_impl.o

#-------------------------------------------------------------------------------------------#