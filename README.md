# Love2D-Benchmarks

This are a few benchmarks for testing the pure performance of Love2D. I implemented a naive approach first and then tried to optimize it.

Useful optimizations(I found so far):
- Use SpriteBatches
- Don't clear that SpriteBatch. Just set the sprites positions(10-20% more performance)

## Benchmarking
- Every benchmark runs for a fixed time(8 seconds by default) and counts every rendered frame
- After running a benchmark it prints the final score to your terminal

You can tweak the benchmark by setting the objectCount in the code, change the running time or tweaking the physics engine.

## Results

**Love 0.10.2**, i5-6260U CPU @ 1.80GHz, Mesa 17.3.8 DRI Intel(R) Iris Graphics 540 (Skylake GT3e), Debian(testing) GNU/Linux Kernel 4.15

| Benchmark | n | Average | Minimum | Maximum | Time(sec) | Object Count |
| --- | --- | --- | --- | --- | --- | --- |
| Circle Physics | 5 | 74077.4 | 72182 | 75747 | 8 | 2000 |
| Circle Physics Optimized | 5 | 75745.6 | 73264 | 78046 | 8 | 2000 |
| Nested Object Logic | 5 | 159450.2 | 150822 | 164416 | 8 | 25000 |
| Nested Object Logic Optimized | 5 | 192663.4 | 190115 | 196776 | 8 | 25000 |
| Huge Tilemap | 5 | 7790316.6 | 7607165 | 7925859 | 36 | 512x512 |

**Love 11.1**, i5-6260U CPU @ 1.80GHz, Mesa 17.3.8 DRI Intel(R) Iris Graphics 540 (Skylake GT3e), Debian(testing) GNU/Linux Kernel 4.15

| Benchmark | n | Average | Minimum | Maximum | Time(sec) | Object Count |
| --- | --- | --- | --- | --- | --- | --- |
| Circle Physics | 5 | 85584.8 | 82073 | 90584 | 8 | 2000 |
| Circle Physics Optimized | 5 | 84876.4 | 82332 | 88819 | 8 | 2000 |
| Nested Object Logic | 5 | 142028.4 | 139074 | 146522 | 8 | 25000 |
| Nested Object Logic Optimized | 5 | 168370.2 | 164101 | 170602 | 8 | 25000 |
| Huge Tilemap | 5 | 7069123 | 7006160 | 7122534 | 36 | 512x512 |

## Project
I will add some more benchmarks every now and then and will write down every optimization I found. The next thing I am currently working on is a high performance tile-renderer.
I am open for any contribution and information on improving my benchmarks as well as suggestions what should be implemented.

## Background
I came from using the godot engine to use Love2D as I found many bottlenecks in the performance of godot. Some while ago I developed a small prototype 2D-game which had alle functionality I wanted but came to the point where the performance of godot wasn't good enough. As I targeted a Raspberry Pi 3 performance was crucial. But even on my development machine I had quite a few frame drops. Maybe I will add the same benchmarks implemented in godot later on.
