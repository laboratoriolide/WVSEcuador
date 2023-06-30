* Este script extrae los datos de Ecuador de la base de datos Timeseries (1981-2022).
* Debes descargar los datos "WVS_TimeSeries_4_0.dta" y cologarlos en la carpeta "data" para poder ejecutar el script.
* Fuente: https://www.worldvaluessurvey.org/WVSDocumentationWV6.jsp 
* Autor: Alonso Quijano Ruiz

* Establece el directorio de trabajo
cd "ruta_del_proyecto/WVSEcuador"

* Carga la base de datos
use "data/WVS_TimeSeries_4_0.dta", clear

* Extrae los datos del Ecuador
keep if COUNTRY_ALPHA == "ECU"

* Guarda la base de datos
save "data/WVSEcuador.dta", replace
