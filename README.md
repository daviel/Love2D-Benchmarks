# Love2D-Benchmarks

This are a few benchmarks for testing the pure performance of Love2D. I implemented a naive approach first and then tried to optimize it.

Useful optimizations(I found so far):
- Use SpriteBatches
- Don't clear that SpriteBatch. Just set the sprites positions(10-20% more performance)
- Use locals: see Circle Physics setObjects method in the optimized version and non-optimized one
- Set friction of your physic-objects to 1(if not otherwise needed) to improve physics performance(15%)
  

## How-To
For automatic testing you can run the testSuite.sh like this: 

    # run all benchmarks 5 times
    ./testSuite
    
    # for 4 iterations per benchmark or as this 
    ./testSuite 4
    
    # for 2 iterations of the Circle Physics benchmark.  
    ./testSuite.sh 2 Circle\ Physics/main.lua 
    
After that you get the result in your console with calculated average, minimum and maximum as well as every result of every iteration.

## Benchmarking
- Every benchmark runs for a fixed time(8 seconds by default) and counts every rendered frame
- After running a benchmark it prints the final score to your terminal

You can tweak the benchmark by setting the objectCount in the code, change the running time or tweaking the physics engine.

## Results

**Love 11.1**, i5-6260U CPU @ 1.80GHz, Mesa 17.3.8 DRI Intel(R) Iris Graphics 540 (Skylake GT3e), Debian(testing) GNU/Linux Kernel 4.15

| Benchmark | n | Average | Minimum | Maximum | Time(sec) | Object Count |
| --- | --- | --- | --- | --- | --- | --- |
| Circle Physics | 5 | 103941 | 75725 | 172992 | 8 | 2000 |
| Circle Physics Optimized | 5 | 135635 | 96290 | 180845 | 8 | 2000 |
| Nested Object Logic | 5 | 142336 | 137918 | 148621 | 8 | 25000 |
| Nested Object Logic Optimized | 5 | 162441 | 159457 | 165195 | 8 | 25000 |
| Huge Tilemap | 5 | 5389719 | 5354886 | 5511811 | 32 | 512x512 |
| Huge Tilemap Optimized | 5 | 5305393 | 5204595 | 5584530 | 32 | 512x512 |
| Huge Tilemap Experimental | 5 | 4506699 | 4329579 | 4779127 | 32 | 512x512 |

**Love 11.1**, Raspberry Pi 3, Mesa 13, Raspbian GNU/Linux Kernel 4.14.34

| Benchmark | n | Average | Minimum | Maximum | Time(sec) | Object Count |
| --- | --- | --- | --- | --- | --- | --- |
| Circle Physics | 5 | 29899 | 28952 | 30704 | 8 | 500 |
| Circle Physics Optimized | 5 | 39698 | 36644 | 46011 | 8 | 500 |
| Nested Object Logic | 5 | 26848 | 24132 | 28590 | 8 | 5000 |
| Nested Object Logic Optimized | 5 | 22156 | 20615 | 23936 | 8 | 5000 |

## Project
I will add some more benchmarks every now and then and will write down every optimization I found.  
  
I am open for any contribution and information on improving my benchmarks as well as suggestions what should be implemented.

## Background
I came from using the godot engine to use Love2D as I found many bottlenecks in the performance of godot. Some while ago I developed a small prototype 2D-game which had alle functionality I wanted but came to the point where the performance of godot wasn't good enough. As I targeted a Raspberry Pi 3 performance was crucial. But even on my development machine I had quite a few frame drops. Maybe I will add the same benchmarks implemented in godot later on.
