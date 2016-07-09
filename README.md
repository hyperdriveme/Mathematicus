# Mathematicus
A swift library for mathematics, aiming at ease of use and average performance. Purely written in swift and makes use of swift's powerful features.
*This is currently a testing version of software. When the first version is published, I will add Carthage and Swift Package Manager support!*

##Why Mathematicus

Swift is an industrial level language, and its protocol-oriented programming style, full support on functional programming and numerous modern features make it a great language. But there is something surely left, that is, a library for mathematics.

I'm working on a small mathematical library for swift to support commonly used math, for example, oridinary differential equations, complex numbers, and polynomials.

It employs a ,some how, strange design pattern to make full use of swift's all powerful protocol oriented programming style, namely, the Theoretical Protocols. This is just defining protocols, which has no actual contents. Doing this is because of mathematics is full of *coincidence*(maybe there is a better word for this since they are actually due to higher level theorems), and the compiler knows nothing about functional analysis or something like that. This trick aims at making the code as clear and expressive as possible.

##Basic Usage
For example, I want to use Mathematicus for my 3-body simulation. I want record my particles' positions and velocities in a large vector, I simply do the following:

``` swift
let v = Vector<Double>(contents: [])
v.contents.appendContentsOf(initialPositionsAndVelocities)
```

and then setup my gravitational field, by creating a function to evaluate the derivatives.

Finally, it is easy to solve ordinary differential eqautions:

```swift
let data = OrdinaryDifferentialEquation<Double>(dimension: 18, initial: v, equations: equationsFromPhysicalFormulas).solve(terminatingTime: 10, step: 0.001)

//data: [Vector<Double>]
```

##Present

Now it is a personal project, and many important features are missing due to the lack of time.

It is in swift 2.2, not 3.0. Swift 3.0 will be adopt as soon as Xcode 8 is available for public beta.

##Future

Mathematicus will adopt high performance algorithms. And it will(for the present plan) support matrices, sinal processing, and symbolic expressions.