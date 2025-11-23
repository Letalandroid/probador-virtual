# Informe de Pruebas Piloto y Resolución de Problemas
## Probador Virtual con IA - Tienda de Ropa en Piura

---

## 1. Pruebas Piloto con Usuarios Externos (Beta Cerrada)

Durante la fase de pruebas piloto con usuarios externos en modalidad beta cerrada, se llevó a cabo una evaluación exhaustiva del sistema de probador virtual con inteligencia artificial. Esta etapa fue fundamental para identificar problemas de usabilidad, errores técnicos y áreas de mejora que no fueron detectadas durante el desarrollo inicial. La retroalimentación recopilada de los usuarios beta proporcionó insights valiosos sobre la experiencia real de uso del sistema en condiciones de producción.

Los usuarios participantes reportaron varios problemas críticos que afectaban directamente la funcionalidad y la percepción del probador virtual. Entre los principales hallazgos se encontró que algunos productos aparecían como invisibles durante el proceso de prueba virtual, lo cual generaba confusión y frustración en los usuarios. Asimismo, se identificó que el sistema permitía intentar probar virtualmente prendas que no eran compatibles con la tecnología actual, específicamente zapatillas y otros artículos que no corresponden a prendas de torso, generando expectativas erróneas y resultados insatisfactorios.

Otro aspecto relevante señalado por los usuarios fue la presentación de las imágenes de productos. Los participantes indicaron que las imágenes de productos que mostraban modelos vestidos con las prendas generaban confusión en el proceso de superposición virtual, ya que la inteligencia artificial tenía dificultades para distinguir entre la prenda y la persona que la portaba en la imagen de referencia. Esta situación afectaba la calidad de los resultados generados y reducía la precisión del probador virtual.

Adicionalmente, se observó que el sistema no proporcionaba orientación clara a los usuarios sobre cómo debían tomar sus fotografías para obtener los mejores resultados posibles. La falta de instrucciones específicas sobre iluminación, encuadre y posición corporal resultaba en imágenes subóptimas que la inteligencia artificial no podía procesar adecuadamente, generando errores en el procesamiento o resultados de baja calidad.

La retroalimentación recopilada durante estas pruebas piloto fue fundamental para priorizar las mejoras necesarias y orientar el desarrollo de ajustes específicos que permitieran resolver los problemas identificados, mejorando significativamente la experiencia de usuario y la confiabilidad del sistema.

---

## 2. Recopilación de Retroalimentación y Ajuste de Funcionalidades

Con base en la retroalimentación obtenida durante las pruebas piloto, se implementaron una serie de ajustes y mejoras orientadas a resolver los problemas identificados y optimizar la funcionalidad del probador virtual. Estos cambios fueron diseñados para mejorar tanto la experiencia del usuario como la precisión técnica del sistema.

### 2.1. Filtrado de Categorías para Probador Virtual

Uno de los ajustes más significativos fue la implementación de un sistema de filtrado inteligente que restringe el uso del probador virtual únicamente a prendas de torso superior. Esta funcionalidad fue desarrollada para resolver el problema reportado por los usuarios sobre la disponibilidad del probador virtual para productos incompatibles, como zapatillas y otros artículos que no pueden ser procesados adecuadamente por la tecnología actual.

El sistema ahora identifica automáticamente las categorías de productos compatibles (Vestidos, Blusas, Sudaderas, Chaquetas y Camisetas) y muestra el botón de probador virtual únicamente cuando el producto pertenece a una de estas categorías. Para productos de otras categorías, el sistema oculta la opción de probador virtual, evitando así generar expectativas erróneas y reduciendo la frustración del usuario. Esta mejora garantiza que solo se ofrezca la funcionalidad de probador virtual cuando técnicamente es viable, mejorando la confiabilidad percibida del sistema.

### 2.2. Implementación de Instrucciones Detalladas para Captura de Fotografías

Para abordar el problema de la falta de orientación sobre cómo tomar fotografías adecuadas, se desarrolló e integró un módulo completo de instrucciones dentro de la interfaz del probador virtual. Este módulo incluye tres aspectos fundamentales que los usuarios deben considerar al capturar sus imágenes: iluminación adecuada, encuadre correcto y posición frontal.

Las instrucciones especifican que la fotografía debe ser tomada en un área bien iluminada para que la inteligencia artificial pueda detectar correctamente la figura del usuario. Se enfatiza que el encuadre debe capturar desde la mitad del cuerpo hacia arriba, mostrando el torso completo desde la cintura hasta la cabeza. Asimismo, se indica claramente que el usuario debe estar posicionado de frente, con el rostro y cuerpo mirando directamente hacia la cámara, ya que esta posición optimiza la capacidad de la IA para realizar la superposición virtual de manera precisa.

Para complementar estas instrucciones textuales, se integró una imagen de ejemplo que muestra visualmente cómo debe verse una fotografía correctamente tomada. Esta imagen de referencia permite a los usuarios comparar su propia captura con el estándar esperado, facilitando la comprensión de los requisitos y mejorando significativamente la calidad de las imágenes subidas al sistema.

Adicionalmente, se incluyó una advertencia destacada que informa a los usuarios que si alguno de estos requisitos no se cumple correctamente, el resultado puede no ser el esperado. Esta transparencia en la comunicación ayuda a gestionar las expectativas y reduce la frustración cuando los resultados no son óptimos debido a imágenes de baja calidad o mal encuadradas.

### 2.3. Optimización del Envío de Datos del Producto

Con el objetivo de mejorar la precisión de los resultados generados por la inteligencia artificial, se implementó una mejora en el sistema de comunicación entre el frontend y el servicio de IA. Ahora, cuando un usuario inicia el proceso de probador virtual, el sistema envía información completa y estructurada del producto, incluyendo nombre, marca, categoría, tallas disponibles, color, género, descripción, cantidad en stock y precio.

Esta información adicional permite a la inteligencia artificial generar resultados más contextualizados y precisos, ya que puede adaptar el procesamiento según las características específicas de la prenda. Por ejemplo, el sistema puede ajustar el estilo de superposición según el tipo de prenda (vestido, blusa, chaqueta, etc.) y considerar aspectos como el género y las tallas disponibles para generar visualizaciones más realistas y personalizadas.

### 2.4. Mejoras en la Presentación de Imágenes de Productos

Aunque la retroalimentación indicó que sería ideal mostrar únicamente las prendas sin modelos en las imágenes de productos, esta mejora requiere cambios en el proceso de gestión de contenido y en la base de datos de imágenes. Sin embargo, se implementaron mejoras en el procesamiento de imágenes que permiten al sistema manejar mejor las imágenes que contienen modelos, optimizando la extracción de la prenda para el proceso de superposición virtual.

Los ajustes implementados como resultado de las pruebas piloto han mejorado significativamente la experiencia de usuario y la funcionalidad del probador virtual. El sistema ahora proporciona una guía clara sobre cómo usar la funcionalidad, restringe su disponibilidad a productos compatibles, y optimiza el procesamiento mediante el envío de información completa del producto. Estas mejoras han resultado en una reducción notable de errores durante el procesamiento y en un aumento de la satisfacción de los usuarios con los resultados obtenidos.

---

## 3. Elaboración de Documentación

Como parte fundamental del proyecto, se desarrolló una documentación completa y estructurada que abarca todos los aspectos necesarios para el uso, administración, desarrollo y despliegue del sistema. Esta documentación fue diseñada para diferentes audiencias, desde usuarios finales hasta desarrolladores y administradores de sistemas, garantizando que cada tipo de usuario tenga acceso a la información relevante para su rol.

### 3.1. Manual de Usuario

Se elaboró un manual de usuario exhaustivo que proporciona una guía completa para todos los usuarios finales de la aplicación. El manual incluye una introducción detallada al sistema, explicando las características principales y los beneficios del probador virtual con inteligencia artificial. Se documentaron paso a paso los procesos de registro e inicio de sesión, incluyendo la recuperación de contraseñas y la gestión de cuentas de usuario.

El manual cubre exhaustivamente la navegación principal del sistema, describiendo cada elemento del header y footer, así como las funcionalidades disponibles para los clientes. Se incluyeron instrucciones detalladas sobre cómo explorar el catálogo de productos, utilizar los filtros de búsqueda, y acceder a los detalles de cada prenda. Asimismo, se documentó el proceso completo de uso del probador virtual, desde la selección de un producto hasta la visualización de los resultados, incluyendo todas las instrucciones necesarias para obtener los mejores resultados posibles.

Para los administradores, el manual incluye una sección completa que describe el acceso al panel de administración, la gestión de productos y categorías, la administración de usuarios, la generación de reportes, y el monitoreo del estado de los servicios. Cada funcionalidad está documentada con pasos claros y ejemplos visuales mediante capturas de pantalla que facilitan la comprensión.

El manual también incorpora una sección de preguntas frecuentes que aborda las dudas más comunes de los usuarios, así como una guía de solución de problemas que ayuda a resolver los inconvenientes técnicos más frecuentes. Todas las imágenes del manual fueron optimizadas para formato A4, utilizando etiquetas HTML con control de tamaño para garantizar una presentación adecuada cuando se convierte a PDF.

### 3.2. Guía Técnica

Se desarrolló una guía técnica completa dirigida a desarrolladores e ingenieros de software. Esta documentación proporciona una visión detallada de la arquitectura del sistema, describiendo la estructura de los tres servicios principales: frontend desarrollado con React y Vite, backend construido con NestJS, y el servicio de inteligencia artificial implementado con Python y FastAPI.

La guía técnica incluye información exhaustiva sobre el stack tecnológico utilizado, incluyendo las versiones específicas de las dependencias y las razones técnicas detrás de cada elección tecnológica. Se documentó la estructura completa del proyecto, explicando la organización de directorios, la separación de responsabilidades, y los patrones de diseño implementados.

Se proporcionaron instrucciones detalladas para la configuración del entorno de desarrollo, incluyendo la instalación de dependencias, la configuración de variables de entorno, y la conexión a la base de datos. La documentación de la base de datos incluye el esquema completo de Prisma, explicando cada modelo, sus relaciones, y los índices implementados para optimizar el rendimiento.

La guía técnica documenta todos los endpoints de la API, incluyendo los métodos HTTP, los parámetros requeridos, los formatos de respuesta, y ejemplos de uso. Se incluyó información detallada sobre el sistema de autenticación y autorización, explicando cómo funciona el sistema de roles y permisos, y cómo se implementan los guards de seguridad.

Para el desarrollo frontend, se documentaron los componentes principales, los hooks personalizados, y las integraciones con el backend. Se incluyeron ejemplos de código y mejores prácticas para el desarrollo de nuevas funcionalidades. Asimismo, se documentaron los procedimientos de testing, incluyendo pruebas unitarias, pruebas de integración, y pruebas end-to-end.

### 3.3. Materiales de Onboarding

Se crearon materiales de onboarding específicos para diferentes tipos de usuarios, facilitando la incorporación rápida y efectiva de nuevos usuarios al sistema. Estos materiales están estructurados en tres categorías principales: onboarding para usuarios clientes, onboarding para administradores, y onboarding para desarrolladores.

Para los usuarios clientes, se desarrolló una guía de inicio rápido que explica los primeros pasos después del registro, cómo navegar por el catálogo, y cómo utilizar el probador virtual por primera vez. Se incluyeron checklists de verificación que permiten a los usuarios asegurarse de haber completado todos los pasos necesarios para aprovechar al máximo las funcionalidades del sistema.

El onboarding para administradores incluye una guía detallada sobre cómo acceder al panel de administración, realizar las tareas más comunes como la gestión de productos y usuarios, y generar reportes. Se proporcionaron ejemplos prácticos y casos de uso reales que ayudan a los administradores a comprender rápidamente cómo gestionar eficientemente el sistema.

Para los desarrolladores, se creó un proceso de onboarding técnico que incluye la configuración del entorno de desarrollo, la comprensión de la arquitectura del sistema, y las mejores prácticas de desarrollo. Se incluyeron recursos de aprendizaje adicionales, enlaces a documentación externa relevante, y guías para contribuir al proyecto.

Todos los materiales de onboarding están diseñados para ser consumidos de forma progresiva, permitiendo a los nuevos usuarios avanzar a su propio ritmo mientras adquieren las competencias necesarias para utilizar el sistema de manera efectiva.

---

## 4. Despliegue en la Nube con Monitoreo

El despliegue de la aplicación en la nube se realizó utilizando una arquitectura distribuida que aprovecha las capacidades de diferentes plataformas de hosting especializadas. Esta estrategia permite optimizar el rendimiento, la escalabilidad y la disponibilidad de cada componente del sistema según sus características específicas.

### 4.1. Arquitectura de Despliegue

La aplicación fue desplegada utilizando una arquitectura de microservicios distribuida en tres plataformas diferentes. El frontend, desarrollado con React y Vite, fue desplegado en Vercel, una plataforma especializada en aplicaciones web modernas que ofrece integración nativa con Git, despliegues automáticos, y un CDN global para optimizar la velocidad de carga.

El backend API, construido con NestJS, fue desplegado en Render, una plataforma de infraestructura como servicio que proporciona contenedores Docker gestionados, escalado automático, y balanceo de carga. Esta elección permite al backend manejar peticiones concurrentes de manera eficiente y escalar según la demanda.

El servicio de inteligencia artificial, implementado con Python y FastAPI, también fue desplegado en Render como un servicio independiente. Esta separación permite escalar el servicio de IA de forma independiente según la carga de procesamiento de imágenes, optimizando los costos y el rendimiento.

La base de datos PostgreSQL fue configurada utilizando Supabase, una plataforma que proporciona una base de datos PostgreSQL gestionada con características adicionales como autenticación integrada, almacenamiento de archivos, y herramientas de administración. Esta solución elimina la necesidad de gestionar manualmente la base de datos mientras proporciona todas las funcionalidades necesarias.

### 4.2. Configuración de Despliegue

Para el frontend en Vercel, se configuró un despliegue automático que se activa con cada push a la rama principal del repositorio. Se configuraron las variables de entorno necesarias para la conexión con el backend, incluyendo la URL del API y las claves de autenticación. Vercel detecta automáticamente el framework React y configura el build process, optimizando automáticamente los assets para producción.

El backend en Render fue configurado como un servicio web que utiliza Docker para el despliegue. Se configuró el Dockerfile para instalar todas las dependencias de Node.js, compilar el código TypeScript, y ejecutar la aplicación NestJS. Se establecieron las variables de entorno necesarias para la conexión con la base de datos Supabase, las claves JWT para autenticación, y la URL del servicio de IA.

El servicio de IA en Render también fue configurado como un servicio web independiente con su propio Dockerfile. Se configuraron las variables de entorno para la API de Google Gemini, los límites de recursos, y las configuraciones de timeout. Se implementó un sistema de health checks que permite a Render verificar automáticamente el estado del servicio.

### 4.3. Integración y Comunicación entre Servicios

Se configuró la comunicación entre los servicios utilizando variables de entorno que contienen las URLs de cada servicio. El frontend se comunica con el backend a través de peticiones HTTP, y el backend se comunica con el servicio de IA mediante peticiones HTTP asíncronas. Se implementaron timeouts y manejo de errores para garantizar que un fallo en un servicio no afecte a los demás.

Se configuraron los CORS (Cross-Origin Resource Sharing) en el backend para permitir las peticiones desde el dominio del frontend en Vercel. Asimismo, se implementaron validaciones de seguridad para prevenir ataques comunes como inyección SQL, XSS, y CSRF.

### 4.4. Monitoreo Básico

Se implementó un sistema básico de monitoreo que permite verificar el estado de los servicios. En el backend, se creó un endpoint de health check que verifica el estado del servicio, la conexión con la base de datos, y la disponibilidad del servicio de IA. Este endpoint utiliza timeouts de 3 segundos para determinar si un servicio está activo o no responde.

En el frontend, se desarrolló un componente de monitoreo integrado en el panel de administración que permite a los administradores verificar el estado de todos los servicios en tiempo real. Este componente realiza peticiones periódicas al endpoint de health check y muestra el estado de cada servicio con indicadores visuales claros.

---

## 5. Monitoreo de Rendimiento y Corrección de Fallas

Durante el desarrollo y despliegue del sistema, se identificaron y resolvieron varios problemas de rendimiento que afectaban la estabilidad y eficiencia de la aplicación, particularmente relacionados con la base de datos y las consultas redundantes.

### 5.1. Identificación de Problemas de Rendimiento

Durante las pruebas en producción, se observó que la base de datos desplegada en Supabase experimentaba caídas periódicas después de cierto tiempo de uso. Este problema no ocurría en otros proyectos similares con el mismo framework, lo que indicaba que el problema estaba relacionado con la forma en que se realizaban las consultas a la base de datos.

Un análisis exhaustivo del código backend reveló múltiples problemas de rendimiento. Se identificaron consultas redundantes que se ejecutaban innecesariamente, operaciones de base de datos que se realizaban de forma secuencial cuando podían ejecutarse en paralelo, y el uso de `include` en Prisma que traía más datos de los necesarios, generando consultas complejas y costosas.

### 5.2. Optimización de Consultas a la Base de Datos

Se implementaron múltiples optimizaciones para reducir la carga en la base de datos y mejorar el rendimiento general del sistema. En el servicio de productos, se eliminaron verificaciones redundantes de existencia antes de realizar operaciones de creación, actualización o eliminación. En su lugar, se implementó un manejo de errores que captura los errores de Prisma relacionados con registros no encontrados o violaciones de restricciones, reduciendo significativamente el número de consultas a la base de datos.

En el servicio de autenticación, se optimizó el proceso de registro de usuarios para que la creación del usuario, la asignación de roles, y la creación del perfil se realicen en una sola transacción atómica utilizando `$transaction` de Prisma. Esto no solo mejora el rendimiento al reducir las consultas, sino que también garantiza la integridad de los datos.

Para el servicio de reportes, se realizó una optimización significativa del método `getProductMovementsReport`. En lugar de usar `include` que genera consultas complejas con múltiples joins, se implementó el uso de `select` para obtener únicamente los campos necesarios. Además, se reemplazaron las consultas anidadas por consultas paralelas utilizando `Promise.all` y `groupBy` para obtener las últimas vistas y pruebas virtuales de productos de manera eficiente.

En el servicio de usuarios, se optimizó el método `changeUserRole` para realizar una consulta mínima de verificación de existencia y luego ejecutar directamente la operación de actualización o creación, eliminando consultas redundantes.

### 5.3. Implementación de Health Checks

Se implementó un sistema completo de health checks que permite monitorear el estado de todos los servicios en tiempo real. En el backend, se creó un endpoint `/health/status` que verifica el estado del backend mismo, la conexión con la base de datos mediante una consulta simple `SELECT 1`, y la disponibilidad del servicio de IA mediante una petición HTTP con timeout.

Este endpoint utiliza `Promise.race` con timeouts de 2.5 segundos para cada verificación individual, y un timeout total de 3 segundos. Si alguna verificación no responde dentro del tiempo límite, se marca como inactiva o con timeout, proporcionando información detallada sobre el estado de cada componente del sistema.

En el frontend, se desarrolló un hook personalizado `useServiceStatus` que realiza peticiones periódicas al endpoint de health check y mantiene el estado actualizado. Se creó un componente `ServiceStatus` que muestra visualmente el estado de cada servicio con badges de colores (verde para activo, rojo para inactivo, amarillo para timeout), incluyendo el tiempo de respuesta y la última verificación.

### 5.4. Gestión de Conexiones de Base de Datos

Se implementó una gestión adecuada del ciclo de vida de las conexiones de Prisma para prevenir conexiones colgantes que podrían causar problemas de rendimiento. Se añadió el método `onModuleDestroy` en el `PrismaService` que cierra todas las conexiones cuando el módulo se destruye, garantizando que no queden conexiones abiertas que consuman recursos innecesariamente.

### 5.5. Optimización de Operaciones de Stock

Se optimizó la actualización de stock de productos para utilizar la operación `increment` de Prisma directamente en la base de datos, eliminando el ciclo de lectura-modificación-escritura que generaba consultas redundantes. Esta optimización no solo mejora el rendimiento, sino que también previene condiciones de carrera al realizar la operación de forma atómica a nivel de base de datos.

### 5.6. Resultados de las Optimizaciones

Las optimizaciones implementadas resultaron en una reducción significativa del número de consultas a la base de datos. El método `getProductMovementsReport` pasó de realizar múltiples consultas anidadas por producto a realizar solo tres consultas en total (una para productos, una para vistas agrupadas, y una para pruebas virtuales agrupadas), independientemente del número de productos.

Estas mejoras eliminaron completamente el problema de caídas periódicas de la base de datos en Supabase, demostrando que el problema estaba relacionado con la sobrecarga generada por consultas redundantes y no con limitaciones de la plataforma. El sistema ahora es más estable, eficiente, y capaz de manejar mayores cargas de trabajo sin experimentar problemas de rendimiento.

