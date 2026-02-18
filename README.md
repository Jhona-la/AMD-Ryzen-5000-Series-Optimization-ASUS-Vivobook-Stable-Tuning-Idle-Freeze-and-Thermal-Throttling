\# 🚀 Guía Maestra de Optimización: AMD Ryzen serie 5000 (Zen 2/3)

\## Enfoque de Seguridad y Longevidad: ASUS Vivobook M513UA (Ryzen 7 5700U)



Este repositorio es una documentación técnico-científica diseñada para solucionar los fallos críticos de diseño térmico y eléctrico en laptops de chasis delgado con procesadores AMD serie 5000. El objetivo es mitigar el \*\*Thermal Throttling\*\*, eliminar el \*\*Idle Freeze\*\* y detener la \*\*degradación acelerada del silicio\*\*.



---



\## 📊 Evidencia Empírica: Análisis de Telemetría



A través de pruebas de carga controladas, se han identificado los dos estados operativos del Ryzen 7 5700U. Los datos demuestran una ineficiencia energética severa en la configuración de fábrica ("Out of the box").



\### Tabla Comparativa de Estrés Térmico



| Parámetro | Configuración Stock (Boost ON) | Configuración Optimizada (Boost OFF) | Impacto / Reducción |

| :--------- | :--------- | :--- | :--- |

| \*\*Frecuencia (All-Core)\*\* | ~3.5 GHz | \*\*~1.8 GHz (Base Freq)\*\* | -1.7 GHz |

| \*\*Temperatura CPU\*\* | \*\*94°C - 95°C\*\* (Límite Crítico) | \*\*~51°C\*\* (Rango Seguro) | \*\*-44% (Delta T)\*\* |

| \*\*Consumo Eléctrico\*\* | ~25W (Promedio Package) | \*\*~7.5W\*\* (Ultra Eficiente) | \*\*-70% Consumo\*\* |

| \*\*Voltaje de Núcleo\*\* | Hasta 1.45V - 1.5V | Estable ~0.9V - 1.1V | Reducción de Vdroop |



\### ⚠️ El Argumento de la Degradación de Componentes

Operar a \*\*95°C\*\* de forma sostenida no es "normal", a pesar de lo que indiquen los límites teóricos del fabricante. En un chasis como el de la Vivobook:

1\. \*\*Pasta Térmica:\*\* Se deseca y pierde conductividad en meses (efecto \*pump-out\*).

2\. \*\*VRMs:\*\* Los reguladores de voltaje sufren un estrés térmico extremo para mantener los \*\*25W\*\*.

3\. \*\*Electromigración:\*\* El uso de voltajes altos (1.5V) a temperaturas altas acelera el desgaste físico de las trazas del procesador.



Al pasar de \*\*25W a 7.5W\*\*, el procesador opera con un margen de seguridad del 300% superior al original.



---



\## 🛠️ Limitaciones de Hardware y Control del Ventilador (EC)



> \*\*DIAGNÓSTICO DEL CONTROLADOR INTEGRADO (EC):\*\*

> Tras múltiples intentos de hacking de registros para forzar una curva de ventilación personalizada (Fan Curve), se ha confirmado que el \*\*Embedded Controller (EC)\*\* de la ASUS Vivobook M513UA está \*\*protegido contra escritura externa\*\*.

>

> \* \*\*Consecuencia:\*\* Herramientas como \*FanControl\* o scripts de terceros no pueden sobreescribir la lógica de ASUS de manera persistente o segura.

> \* \*\*Solución de Seguridad:\*\* Se debe utilizar exclusivamente el \*\*Modo Turbo de G-Helper\*\*. Este modo es el único protocolo autorizado que comunica correctamente con el EC para forzar las RPM máximas del ventilador, compensando la falta de control manual detallado.



---



\## ⚙️ Protocolo de Optimización Paso a Paso



\### 1. Desbloqueo de Gestión de Energía (Regedit)

Windows oculta las llaves que controlan el comportamiento del silicio. Ejecute los siguientes cambios para habilitar la visibilidad de los menús:



\*\*Ruta Raíz:\*\* `HKEY\_LOCAL\_MACHINE\\SYSTEM\\CurrentControlSet\\Control\\Power\\PowerSettings\\54533251-82be-4824-96c1-47b60b740d00\\`



| Sub-Llave | Parámetro | Valor | Función |

| :--- | :--- | :--- | :--- |

| `be337238...c7` | `Attributes` | \*\*2\*\* | Habilita Modo de Impulso |

| `5d76a2ca...ad` | `Attributes` | \*\*2\*\* | Habilita Deshabilitar Inactividad |

| `893df05d...08` | `Attributes` | \*\*2\*\* | Habilita Estados Mín/Máx |



---



\### 2. El Plan de Energía "Master" (Configuración de Seguridad)



Una vez habilitados los menús, configure su plan de energía con los siguientes argumentos técnicos:



\* \*\*Modo de Impulso de Rendimiento:\*\* \*\*Deshabilitado\*\*.

&nbsp; \* \*Argumento:\* Evita que el procesador intente alcanzar los 4.3GHz, lo cual dispara instantáneamente el voltaje y la temperatura a los 95°C mencionados.

\* \*\*Estado Mínimo del Procesador:\*\* \*\*20%\*\*.

&nbsp; \* \*Argumento:\* Configurar al 5% es peligroso en Zen 2/3 (causa caídas de tensión inestables). Configurar al 100% genera calor innecesario. El \*\*20%\*\* es el "colchón" de seguridad que mantiene el VRM activo con un voltaje mínimo constante.

\* \*\*Estado Máximo del Procesador:\*\* \*\*99%\*\*.

&nbsp; \* \*Argumento:\* Fuerza al sistema a ignorar el algoritmo de escalado agresivo del Turbo Boost de Windows.

\* \*\*Deshabilitar Inactividad del Procesador:\*\* \*\*Deshabilitar Inactividad\*\*.

&nbsp; \* \*Argumento:\* Esta es la cura para el \*\*Idle Freeze\*\*. Evita que los núcleos entren en estados de "sueño profundo" (C6/C7) de los cuales no pueden despertar por falta de voltaje (Vdroop).



---



\### 3. Gestión con G-Helper (Sustituto de Armoury Crate)



G-Helper es esencial para eliminar el \*bloatware\* de ASUS que consume ciclos de CPU innecesarios.



1\. \*\*Límites de PPT (Power Package Tracking):\*\*

&nbsp;  \* \*\*Perfil Estabilidad:\*\* Establecer entre \*\*15W y 20W\*\*. (Ideal para gaming prolongado).

&nbsp;  \* \*\*Perfil Potencia:\*\* Máximo \*\*25W - 35W\*\* (Solo si se requiere potencia bruta y se acepta el riesgo térmico).

2\. \*\*Ventilación:\*\* Mantener en modo \*\*Turbo\*\* durante gaming para mitigar el bloqueo del EC.

3\. \*\*Debloat de Servicios:\*\* En "Extra", usar la opción para detener todos los servicios de ASUS. Esto reduce la latencia del sistema (\*DPC Latency\*).



---



\### 4. Ajuste Final: BIOS (Capa de Hardware), esto es lo mismo que Regedit, pero para quienes si tienen esas opciones habilitadas en la BIOS y/o si hay inestabilidad.



Si el sistema presenta inestabilidad incluso tras los pasos anteriores, acceda a la BIOS (F2 al arrancar):

\* \*\*Opción:\*\* `Power Supply Idle Control`.

\* \*\*Ajuste:\*\* \*\*Typical Current Idle\*\*.

\* \*\*Argumento:\*\* Esto instruye al procesador a no bajar nunca de un nivel de corriente mínimo, eliminando cualquier posibilidad de apagado por inactividad.



---



\## 📝 Conclusión de Seguridad

Esta configuración transforma una laptop diseñada para oficina en una estación de trabajo y gaming estable. Se sacrifica frecuencia bruta (3.5GHz) por \*\*consistencia absoluta (1.8GHz)\*\*, bajando el consumo de energía en un \*\*70%\*\* y garantizando que el hardware no sufra daños por calor extremo a largo plazo. Los cambios de Perfil de potencia son bajo el riesgo propio y siempre se recomienda haber creado un punto de restauracion antes de dar inicio a todo este proceso. Yo uso Configuración Stock (Boost ON) solo para jugar, de resto, ni lo aconsejo, ni lo recomiendo.

LLEGAR A ESTE ANALISIS ME LLEVO UNOS DIAS DESPUÉS DE HABER ESTADO 4 AÑOS CON ESTA FALLA, ESPERO QUE TAMBIEN SE LES SOLUCIONE.



---


## 🛠️ Instalación Automática (Recomendado) pero revisa el Script antes de ejecutar.

Para no editar el registro manualmente, puedes usar el script de PowerShell incluido:

1. Descarga `scripts/Unlock_Ryzen_Hidden_Settings.ps1`.
2. Haz clic derecho sobre el archivo y selecciona **"Ejecutar con PowerShell"**.
3. Acepta los permisos de Administrador.
4. Abre tus opciones de energía y aplica los cambios detallados en la guía.



---


## 📊 Evidencia de Telemetría y Configuración

A continuación se detalla el comportamiento térmico del sistema bajo carga y los ajustes realizados en las herramientas de control para mitigar el sobrecalentamiento.

### 1. Telemetría en Carga (Estado Crítico / Boost ON)
En esta captura de **Core Temp**, se observa el procesador Ryzen 7 5700U alcanzando los **95°C - 96°C** en varios núcleos con un consumo de **24.5W**. Esta es la evidencia del riesgo térmico que este repositorio busca solucionar.

![Estado Térmico Crítico](images/Screenshot%202026-02-18%20003454.png)

---

### 2. Configuración de Límites de Energía (G-Helper)
Ajuste de los límites de potencia (**SPL** y **sPPT**) para evitar que el procesador exceda la capacidad de disipación del chasis Vivobook.

![Límites de Energía](images/Screenshot%202026-02-18%20003512.png)

---

### 3. Límite de Temperatura por Software
Configuración del límite térmico forzado a **95°C** en G-Helper como medida de seguridad adicional para prevenir la degradación del silicio.

![Límite de Temperatura](images/Screenshot%202026-02-18%20003521.png)

---

### 4. Modo Turbo y Control de Ventilación
Uso del perfil **Turbo** en G-Helper para forzar el ventilador a **5500 RPM**, logrando el máximo flujo de aire posible ante el bloqueo del controlador integrado (EC).

![Modo Turbo y Fans](images/Screenshot%202026-02-18%20003533.png)

---

### 5. Optimización de Servicios (Debloat)
Evidencia de la detención total de los servicios de ASUS (**Asus Services Running: 0**), liberando recursos críticos y reduciendo procesos en segundo plano.

![Debloat de Servicios](images/Screenshot%202026-02-18%20003545.png)


---

\*\*Autor:\*\* \[Jhona-la]  

\*\*Licencia:\*\* MIT (Libre para compartir y modificar)


---


## Contribuciones

"Si tienes un modelo diferente de la serie 5000 y estos ajustes te funcionaron (o tuviste que ajustarlos), ¡abre un Issue o un Pull Request! Ayudemos a que nadie más queme su laptop."
