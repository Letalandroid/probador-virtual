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

