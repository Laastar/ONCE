Para el desarrollo de la app de Roku recomiendo usar SGDEX para agilizar la inclusión de diferentes funcionalidades, 
hay que prestar atención a los cambios en las bibliotecas usadas en los ejemplos para minimizar errores al momento de
integrarlos.  
https://github.com/rokudev/SceneGraphDeveloperExtensions  

En el caso de Roku se estaba generando las funcionalidades correspondientes con la certificacion  
https://developer.roku.com/es-mx/docs/developer-program/certification/certification.md  
En este caso las certificaciones que nos aplican son para canales de VOD y en VIVO.

Hay que prestar atención en particular a contenido dirigido para Niños ya que aplican políticas 
de uso de la plataforma Roku más restrictivas.

Para el caso de Roku Search, Direct to Play y Deep Linking se requiere de un json que debe ser validado por Roku
y dicho json requiere de una gran cantidad de parámetros.  
https://developer.roku.com/es-mx/docs/specs/search/search-feed.md  
**Estos tres elementos recomiendo ser desarrollen simultáneamente para evitar la mayor cantidad de errores posible ya que dependen entre si mismos todos.**
