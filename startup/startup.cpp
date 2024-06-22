/*
    ******************************************************************************************

    Файл инициализации. Содержит таблицу векторов прерываний и функцию, копирующую данные
    из необходимых секций (.data, .bss) в RAM

    ******************************************************************************************
*/
#include <stdint.h>

void Reset_handler();


extern "C" __attribute__((noreturn)) void stub() {while(1);}

int main();

//------------------------------------------Объявления пользовательских обработчиков-----------//

//---------------------------------------------------------------------------------------------//

__attribute__((section(".isr_vector_table")))
const void * const isr_vector[62] = {
    (void *) 0x20005000, // StackTop
    (void *) &Reset_handler, // Reset_handler
    (void *) &stub, // NMI_Handler
    (void *) &stub, // HardFault_Handler
    (void *) &stub, // MemManage_Handler 
    (void *) &stub, // BusFault_Handler
    (void *) &stub, // UsageFault_Handler
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) &stub, // SVC_Handler
    (void *) &stub, // DebugMon_Handler
    (void *) 0x00, //
    (void *) &stub, // PendSV_Handler
    (void *) &stub, // SysTick_Handler
    (void *) &stub, // WWDG_IRQHandler
    (void *) &stub, // PVD_IRQHandler
    (void *) &stub, // TAMPER_IRQHandler
    (void *) &stub, // RTC_IRQHandler
    (void *) &stub, // FLASH_IRQHandler
    (void *) &stub, // RCC_IRQHandler
    (void *) &stub, // EXTI0_IRQHandler
    (void *) &stub, // EXTI1_IRQHandler
    (void *) &stub, // EXTI2_IRQHandler
    (void *) &stub, // EXTI3_IRQHandler
    (void *) &stub, // EXTI4_IRQHandler
    (void *) &stub, // DMA1_Channel1_IRQHandler
    (void *) &stub, // DMA1_Channel2_IRQHandler
    (void *) &stub, // DMA1_Channel3_IRQHandler
    (void *) &stub, // DMA1_Channel4_IRQHandler
    (void *) &stub, // DMA1_Channel5_IRQHandler
    (void *) &stub, // DMA1_Channel6_IRQHandler
    (void *) &stub, // DMA1_Channel7_IRQHandler
    (void *) &stub, // ADC1_IRQHandler
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) &stub, // EXTI9_5_IRQHandler
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) &stub, // TIM2_IRQHandler
    (void *) &stub, // TIM3_IRQHandler
    (void *) &stub, // TIM4_IRQHandler
    (void *) &stub, // I2C1_EV_IRQHandler
    (void *) &stub, // I2C1_ER_IRQHandler
    (void *) &stub, // I2C2_EV_IRQHandler
    (void *) &stub, // I2C2_ER_IRQHandler
    (void *) &stub, // SPI1_IRQHandler
    (void *) &stub, // SPI2_IRQHandler
    (void *) &stub, // USART1_IRQHandler
    (void *) &stub, // USART2_IRQHandler
    (void *) &stub, // USART3_IRQHandler
    (void *) &stub, // EXTI15_10_IRQHandler
    (void *) &stub, // RTC_Alarm_IRQHandler
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) 0x00, //
    (void *) 0x00  //
};

void Reset_handler() {

    extern uint8_t __data_rom__, __bss_start__, __bss_end__,
    __data_start__, __data_end__;

    //Обнуление bss-секции
    uint8_t *dst = &__bss_start__;
    while(dst < &__bss_end__) {
        *dst = 0;
        dst++;
    }

    //Копирование данных из .data_rom секции в RAM
    dst = &__data_start__;
    uint8_t *src = &__data_rom__; 
    while(dst < &__data_end__) {
        *dst = *src;
        dst++;
        src++;
    }

    main();
    
    stub();

}