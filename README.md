# Weather App

## Video de funcionamiento

[![Título del video](https://img.youtube.com/vi/ID_DEL_VIDEO/hqdefault.jpg)](https://www.youtube.com/watch?v=ID_DEL_VIDEO)

## Herramientas de desarrollo, versión usada y enfoque de dispositivo

- Xcode 16.2  
- iOS 18.2+ 
- Pulse para ver las peticiones a red  
- Enfocado en SwiftUI + MVVM + Combine

---

## Área de enfoque

Me enfoqué principalmente en la arquitectura y el diseño del flujo de datos aunque tambien dedique un tiempo al diseño.

### Arquitectura

Utilicé la arquitectura **MVVM + Combine**.


---

### Capa de acceso a datos

La capa de acceso a datos está compuesta por `Utils` y `Persistence`.

`Utils` proporciona APIs asíncronas para red (networking). `Persistence` proporciona interfaces para almacenar y recuperar datos de lugares y clima. Ambos devuelven datos mediante un `Publisher` del framework Combine. Estas clases son accesibles y utilizadas únicamente por los `Services` en la capa de lógica de negocio.

#### Protocol-oriented networking

Definí los protocolos `APIRequestType` y `APIServiceType`.

Este enfoque evita tener que modificar código existente constantemente para acomodar nuevas solicitudes o tipos de datos. Permite crear tantos tipos de peticiones como se necesiten. Solo se deben agregar nuevas clases que conformen esos protocolos, sin modificar el código ya existente, cumpliendo así con el principio de **Open/Closed**.

Además, este enfoque permite inyección de dependencias, lo que hace el código más testeable.

---

### Capa de lógica de negocio

La capa de lógica de negocio incluye `Services` y `ViewModels`.

Para las características requeridas actualmente, `Services` incluye `PlacesAPIService`, que recibe solicitudes para descargar la lista de lugares deseados desde un endpoint remoto, cabe mencionar que los lugares seleccionados los guarda localmente y posteriormete se revuperan para usarlos en `WeatherAPIService`, que recibe solicitudes para descargar informacion del clima con las coordenadas del lugar.

`ViewModels` actúan entre las `Views` y los `Services`, encapsulando la lógica de negocio para las vistas. Los `ViewModels` son suscriptores downstream que reciben y procesan lo que venga desde los publishers upstream. Se marcan con `@ObservedObject` para que SwiftUI pueda observar sus cambios y actualizar la UI automáticamente.

---

### Capa de presentación

La capa de presentación está representada por `Views`. y en la pantalla de abaut me la realice con `UIKit`

Las vistas son independientes de la lógica de negocio. Muestran la informacion recolectada localmente y de los servicios.

---

## Dependencias Incluidas
En las dependencias adicionales tenemos `Pulse` para ver las peticiones de red en tiempo real en la app de forma visual al usuario, desarrollado por Alexander Grebenyuk. Es gratuito, open source y muy usado en apps profesionales.


---
