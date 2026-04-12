package com.pepbits.core.modernjava.l01.patthernmatching;

import java.util.List;

class ShapeCalculator {

    sealed interface Shape permits Circle, Rectangle, Triangle {}
    record Circle(double radius)               implements Shape {}
    record Rectangle(double width, double height) implements Shape {}
    record Triangle(double base, double height) implements Shape {}

    static double area(Object obj) {
        if (obj instanceof Circle c) {
            return Math.PI * c.radius() * c.radius();
        } else if (obj instanceof Rectangle r) {
            return r.width() * r.height();
        } else if (obj instanceof Triangle t) {
            return 0.5 * t.base() * t.height();
        }
        throw new IllegalArgumentException("Unknown shape: " + obj);
    }

    public static void main(String[] args) {
        List<Object> shapes = List.of(
                new Circle(5.0),
                new Rectangle(4.0, 6.0),
                new Triangle(3.0, 8.0),
                "not a shape"
        );

        for (Object shape : shapes) {
            if (shape instanceof ShapeCalculator.Circle c) {
                System.out.printf("Circle  – radius=%.1f  area=%.2f%n",
                        c.radius(), Math.PI * c.radius() * c.radius());
            } else if (shape instanceof ShapeCalculator.Rectangle r) {
                System.out.printf("Rect    – %.1fx%.1f  area=%.2f%n",
                        r.width(), r.height(), r.width() * r.height());
            } else {
                System.out.println("Other: " + shape);
            }
        }
    }
}
// Output:
// Circle  – radius=5.0  area=78.54
// Rect    – 4.0x6.0  area=24.00
// Other: not a shape
