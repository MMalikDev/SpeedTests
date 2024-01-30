function get_value(key) {
  return process.env[key] | 1;
}

function leibniz(n) {
  let x = 1.0;
  let pi = 1.0;
  for (let i = 2; i < n + 2; i++) {
    x *= -1;
    pi += x / (2 * i - 1);
  }

  return pi * 4;
}

function main() {
  const limit = get_value("LIMIT");
  const runs = get_value("RUNS");
  let pi = 3.1415926535897932;

  const start = performance.now();
  for (let i = 0; i < runs; i++) {
    pi = leibniz(limit);
  }
  const end = performance.now();

  const elapsed = (end - start) / runs;
  console.log(`Elapsed: ${elapsed.toFixed(2)}ms\t| π: ${pi}`);
}

main();
