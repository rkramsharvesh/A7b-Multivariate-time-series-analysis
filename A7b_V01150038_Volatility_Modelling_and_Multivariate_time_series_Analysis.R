# --- Part A: GARCH Modeling of JPM Stock ---

# Load libraries
library(quantmod)
library(rugarch)
library(tseries)
library(FinTS)

# 1. Download data for JPM
getSymbols("JPM", src = "yahoo", from = "2020-01-01", to = "2025-07-17")
price <- na.omit(Cl(JPM))

# 2. Compute log returns
returns <- 100 * diff(log(price))
returns <- na.omit(returns)

# 3. Plot returns
plot(returns, main = "Daily Log Returns: JPM (2020–2025)", ylab = "Log Return (%)")

# 4. ARCH LM Test
ArchTest(returns, lags = 12)

# 5. Fit GARCH(1,1)
spec <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1,1)),
                   mean.model = list(armaOrder = c(0,0)))
fit <- ugarchfit(spec = spec, data = returns)
show(fit)

# 6. Forecast 63-day volatility
forecast <- ugarchforecast(fit, n.ahead = 63)
vol_forecast <- sigma(forecast)

# 7. Plot forecast
plot(vol_forecast, type = "l", main = "Forecasted Daily Volatility (Next 63 Days)", ylab = "Volatility (%)")

# 8. Average volatility
mean(vol_forecast)

# --- Part B: VAR Modeling of Commodity Prices ---

# Load libraries
library(readxl)
library(xts)
library(urca)
library(vars)
library(tseries)

# 1. Load Pink Sheet data
file_path <- "D:/Masters/VCU/Classes/SCMA632/Python/A7b/CMO-Historical-Data-Monthly.xlsx"
df_raw <- read_excel(file_path, sheet = "Monthly Prices", skip = 4)

# Step 1: Remove NA or junk rows first (this line should already be present)
df <- df_raw[, c("...1", "Crude oil, average", "Gold", "Silver")]
colnames(df) <- c("Date", "Crude_Oil", "Gold", "Silver")
df <- df[!is.na(df$Date), ]

# Step 2: Convert Date from '1960M01' to standard Date object
df$Date <- as.character(df$Date)
df$Date <- as.Date(paste0(substr(df$Date, 1, 4), "-", substr(df$Date, 6, 7), "-01"))

# Step 3: Clean numeric columns — remove anything non-numeric explicitly
for (col in c("Crude_Oil", "Gold", "Silver")) {
  df[[col]] <- as.numeric(gsub("[^0-9\\.]", "", df[[col]]))  # Keep only numbers and dot
}

# Step 4: Convert to xts
library(xts)
df_xts <- xts(df[, -1], order.by = df$Date)

# Step 5: Subset from 2010
df_model <- window(df_xts, start = as.Date("2010-01-01"))

# Step 6: Drop any rows with NA (after conversion)
df_model <- na.omit(df_model)

# Step 7: Now safely take log
df_log <- log(df_model)

df_log_diff <- diff(df_log)
df_log_diff <- na.omit(df_log_diff)

# 7. ADF test after differencing
apply(df_log_diff, 2, function(x) adf.test(x)$p.value)

# 8. Johansen Cointegration Test
johansen_test <- ca.jo(df_log, type = "trace", ecdet = "none", K = 2)
summary(johansen_test)

# 9. VAR lag selection
VARselect(df_log_diff, lag.max = 12, type = "const")$selection

# 10. Fit VAR(1)
var_model <- VAR(df_log_diff, p = 1, type = "const")
summary(var_model)

# 11. Stability Check
roots(var_model)

# 12. Impulse Response Functions (12 months)
irf_result <- irf(var_model, impulse = NULL, response = NULL, n.ahead = 12, boot = TRUE)
plot(irf_result)

# 13. Forecast Error Variance Decomposition
fevd_result <- fevd(var_model, n.ahead = 12)
plot(fevd_result)

