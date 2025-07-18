# A7b: Volatility Modelling and Multivariate Time Series Analysis  

## Project Overview

This project explores time series econometric models applied to financial and commodity data using Python and R. The objective is twofold:

- **Part A:** Forecast short-term volatility in equity returns using **ARCH/GARCH models**  
- **Part B:** Analyze interdependencies between **Crude Oil, Gold, and Silver** using **Johansen Cointegration** and **VAR models**

---

## Part A: Volatility Modelling with ARCH/GARCH

- **Asset Analyzed:** JPMorgan Chase & Co. (Ticker: JPM)  
- **Data Source:** [Yahoo Finance](https://finance.yahoo.com)  
- **Timeframe:** Jan 2020 – July 2025 (Daily)  

### Approach:
- Transformed price data into log returns
- Tested for ARCH effects using **ARCH LM Test**
- Modeled volatility using **GARCH(1,1)** from `arch` package
- Forecasted 3-month (63-day) daily volatility

### Key Result:
- Significant ARCH effects confirmed (p < 0.001)
- Strong volatility persistence:  
  - α = 0.1749  
  - β = 0.7131  
- Average daily forecasted volatility ≈ **1.78%**

---

## Part B: Multivariate Time Series Analysis

- **Commodities:** Crude Oil (average), Gold, Silver  
- **Data Source:** [World Bank Pink Sheet](https://www.worldbank.org/en/research/commodity-markets)  
- **Timeframe:** Jan 2010 – Latest Available (Monthly)

### Steps:
- Cleaned and transformed monthly commodity price data
- Performed **ADF tests** → non-stationary in level, stationary in first differences
- Applied **Johansen Cointegration Test**  
- Fitted a **VAR(1)** model on log-differenced data  
- Analyzed:
  - **Impulse Response Functions (IRF)**
  - **Forecast Error Variance Decomposition (FEVD)**

### Key Findings:
- No long-term cointegration found among Crude Oil, Gold, and Silver
- Gold had the strongest self-dependence and moderate influence on Silver
- Crude Oil had limited explanatory power over the other two
- FEVD showed Silver's forecast error variance significantly explained by Gold over time

---

## Conclusion & Applications

This analysis highlights the relevance of:

- **GARCH models** for modeling time-varying volatility in financial assets  
- **VAR models** for understanding short-run interdependencies in commodity markets

While significant ARCH effects validate the need for volatility forecasting in equity returns (e.g., JPM), the multivariate VAR analysis revealed **weak cross-commodity linkages**. Only **Gold exhibited a modest influence on Silver**, with no strong reverse or oil-driven effects.

### Business Applications:
- **Risk Management:** GARCH forecasts can inform Value-at-Risk (VaR) models and portfolio hedging strategies  
- **Commodities Trading:** VAR/FEVD results support targeted hedging across gold and silver, with lesser emphasis on oil linkages  
- **Policy Analysis:** Confirms market segmentation, useful for macroeconomic modeling and inflation-linked instrument pricing

