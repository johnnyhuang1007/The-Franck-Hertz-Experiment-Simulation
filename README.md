# The-Franck-Hertz-Experiment-Simulation
Abstract
---
The Franck-Hertz experiment demonstrates that atoms possess discrete energy states rather than a continuous spectrum. However, there is a lack of detailed explanations in existing literature regarding the actual dynamics of electrons. In this project, we aim to simulate the detailed motion of electrons and discuss the influence of different environmental setups.

![Diagram of the experimental setup](./img/tube.png)
---

Child-Langmuir Law
---
The Current amplitude inside the vacuum tube can be derived from Child-Langmuir Law.  The equation can be expressed as:
$$
I(U_2) = \frac{4}{9} \frac{\epsilon_0}{d^2} \sqrt{\frac{-2q_e}{m_e}} U_2^{3/2} \, \text{mA} \propto U_2^{3/2}
$$
---
Free Mean Path
---
The probability density function of the distance between each collision is:
$$
f_L(l) = \lambda \exp(-\lambda l)
$$
The approximation of vapor pressure of Mercury between 300k to 500k and the formula of free mean path can be described as:
$$
\lambda = \frac{k_B T}{\sqrt{2} \sigma P}, \quad P \approx 8.7 \cdot 10^{(9 - \frac{3110}{T})} \, \text{Pa}
$$

![Electron Trajectory under the field line](./img/electron_motion.png)

---
Selection Rule
---
The states of an atom can be expressed using Term symbol, which has the form 
\( ^{2S+1}L_J \). Transition can occur if it satisfies the selection rule:
$$
\begin{cases}
\Delta L = 0 \text{ or } \pm 1 \\
\Delta J = 0 \text{ or } \pm 1 \quad (0 \nrightarrow 0)
\end{cases}
$$
---
Result
---
![Electron Trajectory under the field line](./img/hg.png)
![Electron Trajectory under the field line](./img/ne.png)
![Electron Trajectory under the field line](./img/comparison.png)
