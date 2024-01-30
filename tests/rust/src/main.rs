use std::env;
use std::time;

fn get_value(key: &str) -> u32 {
    match env::var(key) {
        Ok(v) => v.parse::<u32>().unwrap(),
        Err(_) => 1,
    }
}

fn leibniz(n: u32) -> f64 {
    let pi: f64 = (2..n).fold(1.0, |pi, i| {
        let x: f64 = -1.0f64 + (2.0 * (i & 0x1) as f64);
        pi + x / (2 * i - 1) as f64
    });

    pi * 4.0
}

fn main() {
    let limit: u32 = get_value("LIMIT");
    let runs: u32 = get_value("RUNS");
    let mut pi: f64 = 3.1415926535897932;

    let start: time::Instant = time::Instant::now();
    for _ in 0..runs {
        pi = leibniz(limit);
    }
    let end: time::Duration = start.elapsed();

    let elapsed: f64 = (end.as_nanos() as f64 / 1000000.0) / runs as f64;
    println!("Elapsed: {:.2?}ms\t| π: {:.16?}", elapsed, pi);
}
