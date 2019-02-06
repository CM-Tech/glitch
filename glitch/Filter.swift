import CoreGraphics

struct Filter {
    let r: [CGGammaValue]
    let g: [CGGammaValue]
    let b: [CGGammaValue]

    static let all: [Filter] = [
        Filter(r: [0, 1], g: [0, 1], b: [1, 0]), //Blue-yellow
        Filter(r: [0, 1], g: [1, 0], b: [0, 0]), //Green-red
        Filter(r: [0.25, 0.5], g: [0, 1], b: [1, 0]), //Purple-green
        Filter(r: [1, 0], g: [1, 0], b: [1, 0]), //Invert
        Filter(r: [0.66, 0.1], g: [0.63, 0.1], b: [0, 0.44]),
    ]
}
