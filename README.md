Una herramienta web interactiva de optimización geométrica diseñada para calcular el corte exacto en las esquinas de una lámina rectangular con el fin de maximizar el volumen de una caja abierta, acompañada de un **motor de visualización 3D interactivo**.

---

## 🚀 Características Principales

- **Cálculo Analítico de Optimización:** Utiliza una fórmula matemática exacta derivada para encontrar el punto de inflexión que otorga la máxima capacidad interior de forma inmediata y sin errores de redondeo numérico.
- **Visualizador 3D en Vivo:** Modelo tridimensional interactivo renderizado en SVG puro y controlado mediante JavaScript. Permite rotar la caja arrastrando el cursor y hacer zoom con la rueda del ratón.
- **Soporte Multiusuario y Unidades:** Capacidad de alternar entre milímetros, centímetros, metros, pulgadas y pies con conversión automática en tiempo real.
- **Backend en Perl:** Servidor web ultraligero construido sobre **Mojolicious::Lite**, optimizado para ejecutarse fluidamente en entornos como **Replit**.

---

## 🧮 La Fórmula Matemática y Justificación Técnica

Esta es la fórmula que terminé usando: el volumen de la caja se expresa como un polinomio cúbico en $x$:

$$V(x) = (L - 2x)(W - 2x)x = 4x^3 - 2(L + W)x^2 + LWx$$

Al derivar esta función e igualarla a cero para encontrar los puntos críticos ($V'(x) = 0$), se obtiene una ecuación cuadrática:

$$12x^2 - 4(L + W)x + LW = 0$$

En lugar de utilizar métodos numéricos iterativos (que habrían resultado inútilmente largos, pesados e ineficientes para el código), resolví la ecuación cuadrática mediante la fórmula general de segundo grado y simplifiqué el resultado de forma analítica. 

La solución exacta para el **corte óptimo ($x$)** quedó expresada así:

$$x = \frac{L + W}{6} \left(1 - \sqrt{1 - \frac{3LW}{(L + W)^2}}\right)$$

**¿Por qué hacerlo así?** Al implementar esta fórmula cerrada directamente en el código, me ahorré los problemas de redondeo, evité bucles o aproximaciones numéricas pesadas y recorté al máximo el margen de error, logrando una ejecución limpia, instantánea y matemáticamente perfecta.

---

> Creado por **phoenix.3301** | 2026-2027
