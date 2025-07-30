
# Between Eigen-Values
ev_between <- eigen(cor(between_test, use = "pairwise.complete.obs"))$values

# Within Eigen-Values
ev_within <- eigen(cor(within_test, use = "pairwise.complete.obs"))$values

# Scree plot
par(mfrow = c(1, 2))  # side-by-side plots
plot(ev_between, type = "b", main = "Scree Plot - Between", xlab = "Factor", ylab = "Eigenvalue")
abline(h = 1, col = "red", lty = 2)

plot(ev_within, type = "b", main = "Scree Plot - Within", xlab = "Factor", ylab = "Eigenvalue")
abline(h = 1, col = "red", lty = 2)

# Optional: Parallel analysis (more robust)
fa.parallel(between_test, fa = "fa", n.iter = 100, main = "Parallel Analysis - Between")
fa.parallel(within_test, fa = "fa", n.iter = 100, main = "Parallel Analysis - Within")
