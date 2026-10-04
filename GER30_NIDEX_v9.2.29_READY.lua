-- BUILD: ARS_9_2_29_CLEAN_PULLBACK_UPGRADE_2026_10_02
-- Adaptive Regime Strategy for FXCM Trading Station II / Indicore
-- v9.1.2 HYBRID: cooldown counts only from broker-confirmed trade close; entry time never starts cooldown.
-- Native Indicator Edition — GER30 (DAX) M1 profile
-- Ready profile: CLEAN M1, trend/breakout only, HTF off, global VWAP hard cap 6 ATR, pullback cap 4.5 ATR.
-- Pullback upgrade verified with offline regressions; confirm fresh FXCM instance inputs after loading.
--
-- Version: 9.2.29 HYBRID
-- v9.2.29: optional UPGRADED CLEAN pullbacks (new-profile default): earlier
-- EMA9/20 trend recognition, causal touch memory, dedicated pullback quality
-- and explicit rejection diagnostics. CLASSIC preserves prior entry rules.
-- Existing position management and broker risk limits remain authoritative.
-- 2026-10-02 fix: train exit observer on unchanged managed-bar snapshots;
-- reset only the incompatible exit model and reject old exit snapshots.
-- Resolve broker stops without borrowing another trade's linked stop.
-- Preserve exit context across partial-close lineage; honor ML OFF and
-- persist break-even skips. Prefer qualified CLEAN setup candidates.
-- v9.2.28: exposes separate OFF switches for the shared regime-flip and generic EMA/VWAP thesis-invalidation exits. Both default OFF per GER30 NIDEX request; broker SL/TP, break-even/trailing, max-bars, and setup-specific failure exits remain active.
-- v9.2.27: adds a separate persistent, observe-only exit-context learner. It trains on each confirmed trade result using last-managed-bar R, EMA/VWAP/structure, stop-protection and setup context; it reports an exit probability without changing exit rules. Existing shared entry model and weights remain intact.
-- v9.2.26: expands Smart AI entry snapshots with side-relative EMA9/20/50 distance, EMA spacing/slope, trigger candle and setup-family features. Trade updates and closes record EMA-relative management context. Feature additions are append-only so the existing shared demo/live model weights and counts remain usable; old open-trade feature snapshots are decoded compatibly.
-- v9.2.25: adds an optional CLEAN entry-quality gate with OFF/OBSERVE/ENFORCE modes. OBSERVE is default and only writes ENTRY_QUALITY diagnostics; the 9.2.23 entry rules, two-bar pullback retest, shared model persistence, sizing, stops and management remain intact.
-- v9.2.25: adds an optional CLEAN entry-quality gate with OFF/OBSERVE/ENFORCE modes. OBSERVE is default and only writes ENTRY_QUALITY diagnostics; the 9.2.23 entry rules, two-bar pullback retest, shared model persistence, sizing, stops and management remain intact.
-- v9.2.23: route CLEAN/HYBRID/SHADOW Smart AI entry features through the order and TradeID persistence lifecycle; expose local demo/live model-group sharing; report whether each confirmed trade retained its entry snapshot.
-- v9.2.22: invalidate risk budgets before refresh and fail closed on missing risk data; carry the detected breakout level into setup identity and management; enforce effective trade-family permissions before CLEAN selection; release both engine/global setup reservations after confirmed order rejection.
-- v9.2.21: entry-engine architecture upgrade: operator-selectable CLEAN / LEGACY_V1 / LEGACY_V2 / HYBRID_CONFIRM / SHADOW modes; LEGACY_V2 reduces the old probability/regime maze to four market states, explicit setup candidates, six transparent evidence buckets and one setup-family threshold. Smart Market State is advisory in V2, cross-engine setup fingerprints prevent duplicate reuse, and each open trade persists its entry-engine origin so changing entry mode cannot silently change management of an existing trade.
-- v9.2.20: clean-engine VWAP fade integration: the v9 clean entry path now evaluates genuine VWAP_FADE_LONG / VWAP_FADE_SHORT candidates using the existing VWAP Fade Module permissions, stretch/RSI/rejection/ADX rules, dedicated mean-reversion scoring, REVERSAL stop/target risk geometry, and signal-candle structural anchors. Clean trend/range hierarchy, legacy fade behavior, risk rails, HTF gates, lifecycle, and management are otherwise retained.
-- v9.2.19: exit lifecycle message clarity: immediate successful close submission now reports EXIT_SUBMITTED reason=<reason>, so reasons such as "failed bullish breakout" cannot be misread as submission failures. Immediate submission failure reports EXIT_SUBMIT_FAILED reason=<reason> broker=<message>. Trading and exit conditions are unchanged.
-- v9.2.18: broker-native pip-cost risk upgrade: AUTO_BROKER (default) reads the live Offers.PipCost value, validates it against the offer/source pip size, refreshes before sizing and final risk checks, and fails closed if unavailable. Manual pip value remains an explicit emergency override only. ORDER_PLAN/startup diagnostics expose effective pip value and source.
-- v9.2.17: configurable global VWAP-distance entry veto: optional hard block when absolute close-to-VWAP distance exceeds MaxEntryVWAPDistanceATR; applies before sizing/order planning to both clean and legacy entry engines and reports the exact ATR-distance blocker.
-- v9.2.16: version-label consistency fix: all live diagnostics and strategy descriptions now derive from STRATEGY_NAME/STRATEGY_VERSION instead of stale hard-coded v9.2.14 text; trading, sizing, lifecycle, geometry and ownership behavior are unchanged.
-- v9.2.15: guarded FixedLots now uses the HARD operator risk budget (RiskPct/open-risk/daily-room) while Smart Money scaling remains diagnostic-only for FixedLots and continues to size AdaptiveRisk. RISK_FIT now exposes hardBudget, softBudget, budgetType, and requiredRiskPct so minimum-lot blocks are actionable.
-- v9.2.14: confirmed-close/reset lifecycle upgrade: async close success is EXIT_ACCEPTED (not a fill/close confirmation), final broker closed-row reconciliation emits CLOSE_CONFIRMED and starts cooldown, close accounting now runs before indicator-dependent early returns, and BreakEvenResetsLossStreak makes break-even streak policy explicit.
-- v9.2.13: unified volatility/risk architecture: dedicated ATR-percentile lookback, configurable stop widening, one smooth volatility risk curve (removes stacked high-vol risk cuts), explicit fixed-stop policy, affordability-vs-geometry classification, absolute max-stop veto, RANGE stop/width veto, moved RANGE target-room gate, STOP_DRIVER/RISK_FIT/STOP_PREFLIGHT diagnostics.
-- v9.2.12: clean-entry OneTradePerDirection gate now runs before sizing/ORDER_PLAN, blocking a second LONG or SHORT when that side already has an open strategy trade.
-- v9.2.11: execution diagnostics now distinguish ORDER_SUBMITTED, ORDER_ACCEPTED, OPEN_CONFIRMED (TradeID/fill observed), OPEN_REJECTED, and immediate OPEN_FAILED states.
-- v9.2.10: clean-entry HTF policy gate now runs before sizing/ORDER_PLAN. It enforces fresh-data requirements, HTF neutral policy, and hard BLOCK opposition directly in the clean engine.
-- v9.2.9: ORDER_PLAN diagnostics now include STOP_DETAIL with ATR, configured ATR multiple, volatility widening, ATR/point/spread floors, and final broker stop geometry.
-- v9.2.8: operator-selectable trading timeframe support hardened across bar periods; dynamic key-level history by timeframe, optional ActivityProfile application beyond M1, and timeframe-aware diagnostics.
-- v9.2.7: RANGE lookback separated from breakout lookback; CleanRangeLookback is independently configurable (default 30 bars, 20-50 operator range).
-- v9.2.6: dedicated range engine: no directional EMA-stack requirement for RANGE,
-- range-specific scoring, VWAP mean-reversion quality, breakout-danger guard,
-- graded range-edge quality, and a pre-entry requirement for at least 2R room
-- inside the established configurable range window. Trend/pullback/breakout/management logic unchanged.
-- v9.2.2: debug pass: clean pullback now requires MinTrendADX; full-stack toggle is honored by state classification; clean-state management no longer falls through to the legacy generic EMA50+VWAP thesis exit; EMA9/EMA20 touch/reclaim pairing and labels corrected.
-- v9.2.0: fixed missing CleanRequireFullEMAStack runtime binding; startup now reports the real clean EMA-stack setting; clean-parameter binding audit passed.
-- v9.1.7: setup-reuse identity enforcement for clean engine plus clean-state exit integration.
-- v9.1.5: trend-pullback state recognition added; aligned EMA/DMI trend keeps direction during limited counter-momentum retracement.
-- Entry arbitration is replaced; broker SL/TP, BE/ATR ratchet, profit lock, giveback,
-- max-bars, mandatory close, pending reconciliation, FIFO protections and risk rails retained.
-- r3: cash-consistent ML R; bounded state hysteresis; reconstructed key levels;
-- guarded fixed/adaptive sizing with cost, open-risk and daily-room budgets;
-- fresh order preflight; actual broker-stop ratchet; entry-aware excursions;
-- protective exits continue during indicator outages. Monetary limits are
-- planned estimates, not guarantees against gaps/slippage or unrelated trades.
-- FixedLotRiskGuard defaults ON: broker Offers.PipCost is used by default; manual pip value is an explicit override.
-- r2: AGGRESSIVE is the default; M1 aggressive state minimum 40, ordinary
-- setup reuse 5 bars, AUTO_SMART family exclusion only at confidence >=65.
-- Fresh pullback-event protection, explicit trade-type switches and all
-- monetary/exposure/broker risk limits are retained. Frequency is not assured.
-- r1: M1-only activity presets; unrelaxed evidence for adaptive sizing;
-- incremental efficiency window; cached model namespace; lazy CSV formatting.
-- Existing score/edge presets and broker protection are retained. FixedLots remains
-- the default, with monetary sizing caps enabled by FixedLotRiskGuard.
-- Typical GER30 M1: median ATR ~5.8 pts, bar range ~5.5, open spread ~1.3 pts.
-- Closed-bar only (not exchange HFT). Broker protection and fail-closed risk retained.
--
-- Market Outlook: closed-candle behavior + next 3-bar UP/DOWN/SIDEWAYS evidence.
-- Diagnostic outlook only; heuristic confidence is not a win probability.
-- 8.4.19: ActivityProfile (BALANCED/ACTIVE/AGGRESSIVE) for more M1 trades —
-- lower score/edge, shorter cooldown, looser geometry. Risk rails retained.
-- 8.4.18: smart compact diagnostic always shows top blockers + VWAP distance.
-- 8.4.17: strict type permissions, qualified-candidate selection, stop floors,
-- per-bar pullback caching. Existing RR targets and risk limits preserved.
-- Architecture:
--   * Native EMA/MVA, ATR, DMI/ADX, RSI, Bollinger, VWAP, volume → regime / structure / score
--   * Confirmed non-look-ahead pivots (HH/HL/LH/LL, BOS, CHOCH)
--   * Probability Edge Engine (0–100 evidence) + Smart Evidence + State AI + optional Smart AI veto
--   * Session gates (UTC global sessions, optional CET lunch, news) — entries only; management continues
--   * Key Levels: Asian H/L, prior UTC-day H/L, London opening range → breakout / false-breakout paths
--   * Smart money/trade management: adaptive risk, BE trail, optional lock/tighten/CHOCH/giveback
--
-- Live risk:
--   * Every entry submits broker-resident stop + limit
--   * After BreakEvenR, stop ratchets via TrailATR; market close is fallback
--   * AdaptiveRisk/guarded FixedLots use broker Offers.PipCost by default and fail closed if unavailable
--
local STRATEGY_NAME = "GER30 NIDEX"
local STRATEGY_VERSION = "9.2.29"
-- Packed constants + nested helpers keep the main chunk under Lua 5.1's
-- hard limit of 200 local variables (Indicore reports this as
-- "main function has more than 200 local variables").
local Const = {
    MAIN_SOURCE_ID = 1,
    HTF_SOURCE_ID = 2,
    EXIT_SOURCE_ID = 3,
    LOSS_EPSILON = 0.01, -- account-currency tolerance for break-even classification
    CUSTOM_ID_PLACEHOLDER = "SET_UNIQUE_INSTANCE_ID",
    TERMINAL_DIAGNOSTIC_CHUNK_LENGTH = 1450,
}

-- Group mutable state into tables to stay below Lua 5.1/Indicore's
-- 60-upvalue limit per function and to keep each strategy instance isolated.
local Cfg = {}
local Rt = {}

-- Only these entry gates are affected by the activity preset. Keeping the
-- original values separately prevents a frequency change from increasing
-- quality-based position sizing. No broker/risk setting belongs in this list.
Cfg.ActivityGates = {
    {"ProbabilityScoreMin", 47.0, 44.0},
    {"ProbabilityEdgeMin", 3.5, 2.5},
    {"MinBucketDirection", 4.5, 3.5},
    {"MinBucketStructure", 2.5, 2.0},
    {"MinBucketLocation", 3.0, 2.5},
    {"MinBucketMomentum", 2.5, 2.0},
    {"ProbabilityPullbackMaxEntryGapATR", 0.85, 1.00, "MAX"},
    {"TrendPullbackMaxCloseATR", 0.75, 0.90, "MAX"},
    {"PullbackMinRetraceATR", 0.12, 0.10},
    {"PullbackMinBodyATR", 0.08, 0.05},
    {"SmartThinMarginScoreAdd", 0.5, 0.0},
    {"SmartHighVolScoreAdd", 0.5, 0.0},
    {"StateAILowConfScoreAdd", 3.0, 2.0},
    {"SmartStateMinConfidence", nil, 40.0},
    {"SetupResetBars", nil, 5},
}

function Cfg.applyActivityProfile()
    assert(Cfg.ActivityProfile == "BALANCED" or Cfg.ActivityProfile == "ACTIVE"
        or Cfg.ActivityProfile == "AGGRESSIVE", "Invalid Activity Profile")
    Cfg.ActivityEffectiveProfile = (Cfg.TF == "m1" or Cfg.ApplyActivityProfileAllTF == true) and Cfg.ActivityProfile or "BALANCED"
    Cfg.ActivityBase = setmetatable({}, {__index=Cfg})
    -- Keep the v9.2.26 entry-model identity while this release only adds
    -- observations and the separate exit learner; shared demo entry learning continues.
    local identity = {"9.2.26", Cfg.ActivityProfile, Cfg.ActivityEffectiveProfile}
    for _, gate in ipairs(Cfg.ActivityGates) do
        local name = gate[1]
        local value = assert(tonumber(Cfg[name]), "Missing activity gate: " .. name)
        Cfg.ActivityBase[name] = value
        identity[#identity + 1] = name .. "=" .. tostring(value)
        if Cfg.ActivityEffectiveProfile ~= "BALANCED" then
            local preset = gate[Cfg.ActivityEffectiveProfile == "AGGRESSIVE" and 3 or 2]
            if preset ~= nil then
                Cfg[name] = gate[4] == "MAX" and math.max(value, preset) or math.min(value, preset)
            end
        end
    end
    Cfg.ActivityIdentity = table.concat(identity, "|")
end

local Ind = {}
Ind.emaFast = {}
Ind.emaMed = {}
Ind.emaSlow = {}
Ind.atr = {}
Ind.plusDI = {}
Ind.minusDI = {}
Ind.adx = {}
Ind.rsi = {}
Ind.bbWidth = {}
Ind.vwap = {}
Ind.efficiency = {}
Ind.avgVolume = {}
Ind.swingHigh = {}
Ind.swingLow = {}

-- =========================
-- Configuration / state
-- =========================


local Context = {}
local Scores = {}
Rt.currentRegime = "NONE"
Rt.currentBaseRegime = "NONE"
Rt.smartState = "UNKNOWN"
Rt.smartStateConfidence = 0
Rt.smartStateNote = "init"
Rt.smartStateBias = "NEUTRAL"
Rt.htfTrend = 0
Rt.htfStrength = 0
Rt.htfGapATR = 0
Rt.htfSlopeATR = 0
Rt.consecutiveLosses = 0
Rt.indHistoryBackfilled = false
Rt.lastCopiedPeriod = nil
Rt.knownClosedTrades = {}
Rt.closedHistoryInitialized = false
Rt.Native = { outputsUpdated = false, htfInitialized = false }
Rt.lastHTFPeriod = nil
Rt.htfStatus = "NO_CALLBACK"
Rt.htfBarDurationMinutes = nil

-- Per-trade trailing-stop state, keyed by broker TradeID. This is what makes
-- the thesis stop an actual ratchet instead of a value recomputed from
-- scratch every bar (see updateTrailingStop()/manageOpenPositions()).
Rt.trailStops = {}       -- TradeID -> highest(long)/lowest(short) thesis stop reached so far
Rt.tradeInitialRisk = {} -- TradeID -> stop distance actually sent to the broker at entry
Rt.tradeEntryRegime = {} -- TradeID -> regime at entry
Rt.tradeEntryEngine = {} -- TradeID -> CLEAN / LEGACY_V1 / LEGACY_V2 / HYBRID_CONFIRM / SHADOW
Rt.tradeSetupAnchor = {} -- TradeID -> structural price anchoring its entry setup
Rt.usedSetupKeys = {}    -- setup key -> entry period; blocks repeated use of one setup
Rt.pendingOpenRequests = {} -- OpenOrderReqID -> {risk, side}
Rt.pendingUnknownOpen = nil -- guarded fallback when a host omits the request ID
Rt.fifoClosePending = {} -- side -> {period,cookie} while a net close awaits table confirmation
Rt.closePendingTradeIds = {} -- TradeID -> {period,cookie} while a per-trade close awaits confirmation
Rt.pendingOpenCookies = {} -- unique async cookie -> {requestId, pending}
Rt.pendingCloseCookies = {} -- unique async cookie -> {tradeId or fifoSide}
Rt.awaitingCloseReconciliation = {} -- vanished TradeID -> fail-closed until closed row is published
Rt.pendingStopEdits = {} -- TradeID -> {cookie, orderId, requestedRate, period}
Rt.pendingStopEditCookies = {} -- unique async cookie -> pending stop-edit record
Rt.brokerStopRates = {} -- TradeID -> tightest broker stop confirmed/submitted
Rt.stopOrderWarnings = {} -- TradeID -> last discovery problem, de-duplicates alerts
Rt.nextAsyncCookie = 1000
Rt.ML = nil -- initialized in resetRuntimeState()/initializeMLStorage()
Rt.tradeMLFeatures = {} -- TradeID -> immutable entry feature vector
Rt.tradeExitFeatures = {} -- TradeID -> latest reliable open-trade state vector for exit-context learning
Rt.tradeLineageRoot = {} -- remaining TradeID -> original TradeID across partial closes
Rt.cleanPullbackPending = {} -- diagnostic cache; causal events rebuild from closed history
Rt.cleanPullbackDetails = {}
Rt.tradeAnalytics = {} -- TradeID -> diagnostics-only entry/MFE/MAE snapshot
Rt.tradeExitReasons = {} -- TradeID -> last strategy-submitted close reason

-- Smart AI v5 entry-feature snapshot. Features are appended to the v4 list
-- without changing any existing definitions, so persisted v4 classifier
-- weights remain compatible; newly added weights begin at zero and learn from
-- subsequent confirmed closes. Trade snapshots carry a separate schema tag.
Const.ML_FEATURE_SCHEMA = 5
-- Schema/model 1 trained on final-fill data. Keep entry keys and namespace,
-- but start a separate clean exit observer and reject those old snapshots.
Const.ML_EXIT_FEATURE_SCHEMA = 2
Const.ML_EXIT_MODEL_VERSION = 2
Const.ML_EXIT_FEATURE_NAMES = {
    "bias", "currentR", "mfeR", "maeR", "givebackR", "barsHeld",
    "priceFastEMA", "priceMediumEMA", "priceSlowEMA",
    "fastMediumEMAGap", "mediumSlowEMAGap", "fastEMASlope", "mediumEMASlope",
    "vwapAlignment", "momentumAlignment", "dmiAlignment", "adxStrength",
    "emaStackAligned", "breakEvenActive", "stopInProfit",
    "setupPullback", "setupBreakout", "setupContinuation", "setupRange",
    "setupFade", "setupReversal"
}
Const.ML_FEATURE_NAMES_V4 = {
    "bias", "ruleQuality", "regimeMargin", "adxStrength", "dmiAlignment",
    "rsiAlignment", "momentumAlignment", "vwapAlignment", "vwapStretch",
    "efficiency", "atrPercentile", "bbPercentile", "rangeEdge",
    "compression", "htfAlignment", "spreadCost", "sideShort",
    "sessionSydney", "sessionSydneyTokyo", "sessionTokyo",
    "sessionTokyoLondon", "sessionLondon", "sessionLondonNewYork",
    "sessionNewYork", "sessionOffHours", "regimeTrend", "regimeRange",
    "regimeBreakout", "regimeReversal",
    "structureBias", "structureQuality", "structureConfidence",
    "chochOppose", "bosAlign", "stateAlign", "stateConfidence",
    "evidenceEdge", "lossStreak", "volQuiet", "volHigh"
}
local ML_FEATURE_NAMES = {
    "bias", "ruleQuality", "regimeMargin", "adxStrength", "dmiAlignment",
    "rsiAlignment", "momentumAlignment", "vwapAlignment", "vwapStretch",
    "efficiency", "atrPercentile", "bbPercentile", "rangeEdge",
    "compression", "htfAlignment", "spreadCost", "sideShort",
    "sessionSydney", "sessionSydneyTokyo", "sessionTokyo",
    "sessionTokyoLondon", "sessionLondon", "sessionLondonNewYork",
    "sessionNewYork", "sessionOffHours", "regimeTrend", "regimeRange",
    "regimeBreakout", "regimeReversal",
    "structureBias", "structureQuality", "structureConfidence",
    "chochOppose", "bosAlign", "stateAlign", "stateConfidence",
    "evidenceEdge", "lossStreak", "volQuiet", "volHigh",
    "priceFastEMA", "priceMediumEMA", "priceSlowEMA",
    "fastMediumEMAGap", "mediumSlowEMAGap", "fastEMASlope", "mediumEMASlope",
    "fastEMATouchDepth", "mediumEMATouchDepth", "triggerBody", "triggerCloseLocation",
    "setupPullback", "setupBreakout", "setupContinuation", "setupRange",
    "setupFade", "setupReversal"
}
-- TradeID -> {reason, sinceBar}. Set whenever closeTrade() refuses to submit
-- a FIFO/netting close because an unrelated same-side position exists on this
-- instrument. While this is set, NONE of this trade's synthetic protection
-- (thesis stop, regime-flip exit, max-bars exit, mandatory close) can reach
-- the broker - only the original static stop remains in effect. Surfaced in
-- traceFullBar() so it can't silently persist unnoticed across many bars.
Rt.blockedExits = {}
Rt.barIndexFallbackWarned = {} -- TradeID -> true, one-time alert when findDate can't resolve the open bar
Rt.tradeRecoveryWarned = {}
Rt.tradeRiskUnavailable = {}
Rt.tradeRecovered = {}
Rt.copyRecoveryFrom = nil
Rt.marketStructure = {}
Rt.lowVolatilityDetected = false
Rt.lowVolatilityScore = 0
Rt.lowVolatilityDecision = "NOT_DETECTED"
Rt.lowVolatilityCandidate = "NONE"
Rt.lowVolatilityReason = "none"

-- =========================
-- Utility
-- =========================
local function clamp(v, lo, hi)
    if v < lo then return lo end
    if v > hi then return hi end
    return v
end

local function abs(v) return math.abs(v) end
local function max(a,b) if a > b then return a else return b end end
local function min(a,b) if a < b then return a else return b end end

local function safeDiv(a, b, fallback)
    if b == nil or b == 0 then return fallback or 0 end
    return a / b
end

local function validNumber(v)
    return type(v) == "number" and v == v and v ~= math.huge and v ~= -math.huge
end

-- Defined before every analytics/execution caller. In Lua, a later
-- "local function" declaration is not visible to functions compiled above
-- it; keeping this primitive in the utility section prevents those callers
-- from accidentally resolving a nil global named yn.
local function yn(v)
    return v and "Y" or "N"
end

local function timeframeMinutes(tf)
    -- Best-effort parse of FXCM/Indicore timeframe codes (s5/s10/.../m1/m5/...
    -- /H1/H4/.../D1/W1/M1) into minutes. Returns nil if unrecognized so
    -- callers can fail closed rather than assume a wrong duration.
    if type(tf) ~= "string" then return nil end
    local unit, num = string.match(tf, "^(%a)(%d+)$")
    if unit == nil or num == nil then return nil end
    num = tonumber(num)
    if num == nil then return nil end
    -- Case matters: m1 is one minute while M1 is one month.
    if unit == "s" then return num / 60.0 end
    if unit == "m" then return num end
    if unit == "h" or unit == "H" then return num * 60.0 end
    if unit == "d" or unit == "D" then return num * 1440.0 end
    if unit == "w" or unit == "W" then return num * 10080.0 end
    return nil -- monthly/yearly bars have no fixed minute duration
end

local function timeframeOrderMinutes(tf)
    local fixed = timeframeMinutes(tf)
    if fixed ~= nil then return fixed end
    if type(tf) ~= "string" then return nil end
    local unit, num = string.match(tf, "^(%a)(%d+)$")
    num = tonumber(num)
    if num == nil then return nil end
    -- Approximate values are used ONLY to validate ordering, never elapsed time.
    if unit == "M" then return num * 43200.0 end
    if unit == "Y" or unit == "y" then return num * 525960.0 end
    return nil
end

local function roundDownToBase(units)
    if Rt.BaseSize == nil or Rt.BaseSize <= 0 then return 0 end
    return math.floor(units / Rt.BaseSize) * Rt.BaseSize
end

local function ParseTime(time)
    if type(time) ~= "string" then return nil, false end
    local p = string.find(time, ":")
    if p == nil then return nil, false end
    local h = tonumber(string.sub(time, 1, p - 1))
    time = string.sub(time, p + 1)
    p = string.find(time, ":")
    if p == nil then return nil, false end
    local m = tonumber(string.sub(time, 1, p - 1))
    local s = tonumber(string.sub(time, p + 1))
    if h == nil or m == nil or s == nil then return nil, false end
    local integral = h == math.floor(h) and m == math.floor(m) and s == math.floor(s)
    local ok = integral and ((h >= 0 and h < 24 and m >= 0 and m < 60 and s >= 0 and s < 60) or
                (h == 24 and m == 0 and s == 0))
    return (h / 24.0 + m / 1440.0 + s / 86400.0), ok
end

local function InRange(now, openTime, closeTime, equalMeansAll)
    -- All configured windows are half-open: the opening instant belongs to the
    -- window and the closing instant does not. This matches global sessions and
    -- prevents a StopTime/lunch-end boundary bar from being classified twice.
    if openTime < closeTime then return now >= openTime and now < closeTime end
    if openTime > closeTime then return now >= openTime or now < closeTime end
    if equalMeansAll then return true end
    return now == openTime
end

local function getSessionTime(dateValue)
    -- Use the bar timestamp when supplied so live trading and backtests evaluate
    -- the same historical session window. FXTS price dates are handled as EST
    -- here, matching the strategy/helper conventions used by the working examples.
    local now = dateValue or core.host:execute("getServerTime")
    now = core.host:execute("convertTime", core.TZ_EST, Rt.ToTime, now)
    return now, now - math.floor(now)
end

local function sessionWindowActive(clock, openTime, closeTime)
    -- Half-open windows prevent a boundary bar from belonging to both the
    -- session that just closed and the one that just opened.
    if clock == nil or openTime == nil or closeTime == nil then return false end
    -- Indicore serial dates can land a few microseconds either side of an
    -- exact clock boundary. Configured windows have whole-second precision.
    clock = math.floor(clock * 86400 + 0.5) % 86400
    openTime = math.floor(openTime * 86400 + 0.5) % 86400
    closeTime = math.floor(closeTime * 86400 + 0.5) % 86400
    if openTime < closeTime then return clock >= openTime and clock < closeTime end
    if openTime > closeTime then return clock >= openTime or clock < closeTime end
    return false
end

local function globalMarketSession(barDate)
    if barDate == nil then return "UNAVAILABLE", nil end
    local utcDate = core.host:execute("convertTime", core.TZ_EST, core.TZ_UTC, barDate)
    if not validNumber(utcDate) then return "UNAVAILABLE", nil end
    local clock = utcDate - math.floor(utcDate)

    local sydney = sessionWindowActive(clock, Rt.SydneyOpen, Rt.SydneyClose)
    local tokyo = sessionWindowActive(clock, Rt.TokyoOpen, Rt.TokyoClose)
    local london = sessionWindowActive(clock, Rt.LondonOpen, Rt.LondonClose)
    local newYork = sessionWindowActive(clock, Rt.NewYorkOpen, Rt.NewYorkClose)

    -- Overlaps are exclusive states and take priority over their component
    -- sessions. Independent overlap switches therefore work as operators
    -- expect: disabling London does not automatically disable London/New York.
    if london and newYork then return "LONDON_NEW_YORK_OVERLAP", clock end
    if tokyo and london then return "TOKYO_LONDON_OVERLAP", clock end
    if sydney and tokyo then return "SYDNEY_TOKYO_OVERLAP", clock end
    if newYork then return "NEW_YORK", clock end
    if london then return "LONDON", clock end
    if tokyo then return "TOKYO", clock end
    if sydney then return "SYDNEY", clock end
    return "OFF_HOURS", clock
end

local function globalMarketSessionAllowed(barDate)
    local session, clock = globalMarketSession(barDate)
    Rt.activeMarketSession = session
    Rt.activeMarketSessionClock = clock
    if not Cfg.UseGlobalSessionFilter then return true, session, clock end
    if session == "SYDNEY" then return Cfg.TradeSydney, session, clock end
    if session == "SYDNEY_TOKYO_OVERLAP" then return Cfg.TradeSydneyTokyoOverlap, session, clock end
    if session == "TOKYO" then return Cfg.TradeTokyo, session, clock end
    if session == "TOKYO_LONDON_OVERLAP" then return Cfg.TradeTokyoLondonOverlap, session, clock end
    if session == "LONDON" then return Cfg.TradeLondon, session, clock end
    if session == "LONDON_NEW_YORK_OVERLAP" then return Cfg.TradeLondonNewYorkOverlap, session, clock end
    if session == "NEW_YORK" then return Cfg.TradeNewYork, session, clock end
    if session == "OFF_HOURS" then return Cfg.TradeOffHours, session, clock end
    return false, session, clock -- fail closed if time conversion is unavailable
end

local function streamBarEndDate(stream, p, timeframe)
    local openDate = stream ~= nil and stream:date(p) or nil
    if openDate == nil then return nil end
    local ok, _, endDate = pcall(function()
        return core.getcandle(timeframe, openDate, Rt.TradingDayOffset or 0, Rt.TradingWeekOffset or 0)
    end)
    if ok and validNumber(endDate) and endDate > openDate then return endDate end
    local minutes = timeframeMinutes(timeframe)
    if minutes ~= nil and minutes > 0 then return openDate + minutes / 1440.0 end
    return openDate
end

local function closedBarEndDate(p)
    return streamBarEndDate(Rt.Source, p, Cfg.TF)
end

local function trimText(value)
    if type(value) ~= "string" then return "" end
    return (string.gsub(string.gsub(value, "^%s+", ""), "%s+$", ""))
end

local function leapYear(year)
    return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

local function daysInMonth(year, month)
    local days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}
    if month == 2 and leapYear(year) then return 29 end
    return days[month]
end

local function civilMinuteKey(year, month, day, hour, minute)
    -- Proleptic Gregorian day number. Only differences between keys matter;
    -- no platform locale, DST setting, or Unix-time conversion is involved.
    local adjustedYear = year
    if month <= 2 then adjustedYear = adjustedYear - 1 end
    local era = math.floor(adjustedYear / 400)
    local yearOfEra = adjustedYear - era * 400
    local shiftedMonth = month > 2 and month - 3 or month + 9
    local dayOfYear = math.floor((153 * shiftedMonth + 2) / 5) + day - 1
    local dayOfEra = yearOfEra * 365 + math.floor(yearOfEra / 4)
        - math.floor(yearOfEra / 100) + dayOfYear
    return (era * 146097 + dayOfEra) * 1440 + hour * 60 + minute
end

local function formatNewsEventUTC(event)
    return string.format("%04d-%02d-%02d %02d:%02d UTC", event.year,
        event.month, event.day, event.hour, event.minute)
end

local function parseNewsSchedule(scheduleText)
    local schedule = trimText(scheduleText)
    if schedule == "" then return {}, false, "schedule is empty" end

    local events = {}
    local itemNumber = 0
    for rawItem in string.gmatch(schedule .. ";", "(.-);") do
        local item = trimText(rawItem)
        if item ~= "" then
            itemNumber = itemNumber + 1
            local dateText, label = string.match(item, "^(.-)%s*|%s*(.*)$")
            if dateText == nil then dateText, label = item, "NEWS" end
            dateText, label = trimText(dateText), trimText(label)
            if label == "" then label = "NEWS" end

            local y, mo, d, h, mi = string.match(dateText,
                "^(%d%d%d%d)%-(%d%d)%-(%d%d)%s+(%d%d):(%d%d)$")
            y, mo, d, h, mi = tonumber(y), tonumber(mo), tonumber(d), tonumber(h), tonumber(mi)
            if y == nil or y < 1970 or y > 2200 or mo == nil or mo < 1 or mo > 12
                or d == nil or d < 1 or d > (daysInMonth(y, mo) or 0)
                or h == nil or h < 0 or h > 23 or mi == nil or mi < 0 or mi > 59 then
                return {}, false, string.format("invalid event #%d '%s'; expected YYYY-MM-DD HH:MM|Label",
                    itemNumber, item)
            end
            events[#events + 1] = {year=y, month=mo, day=d, hour=h, minute=mi,
                label=label, key=civilMinuteKey(y, mo, d, h, mi)}
            if #events > 1000 then return {}, false, "schedule exceeds 1000 events" end
        end
    end
    if #events == 0 then return {}, false, "schedule is empty" end

    table.sort(events, function(a, b)
        if a.key ~= b.key then return a.key < b.key end
        return a.label < b.label
    end)
    local merged = {}
    for i = 1, #events do
        local event = events[i]
        local previous = merged[#merged]
        if previous ~= nil and previous.key == event.key then
            if not string.find("|" .. previous.label .. "|", "|" .. event.label .. "|", 1, true) then
                previous.label = previous.label .. " + " .. event.label
            end
        else
            merged[#merged + 1] = event
        end
    end
    return merged, true, string.format("%d event(s) loaded", #merged)
end

local function newsFilterStatus(barDate)
    if not Cfg.UseNewsFilter then return true, "news filter off" end
    if not Rt.newsScheduleOK or Rt.newsEvents == nil or #Rt.newsEvents == 0 then
        return false, "news filter fail-closed: " .. tostring(Rt.newsScheduleStatus or "schedule unavailable")
    end
    if barDate == nil then return false, "news filter fail-closed: bar time unavailable" end

    local okUTC, utcDate = pcall(function()
        return core.host:execute("convertTime", core.TZ_EST, core.TZ_UTC, barDate)
    end)
    if not okUTC or not validNumber(utcDate) then
        return false, "news filter fail-closed: UTC conversion unavailable"
    end
    local okTable, t = pcall(function() return core.dateToTable(utcDate) end)
    if not okTable or type(t) ~= "table" or t.year == nil or t.month == nil
        or t.day == nil or t.hour == nil or t.min == nil then
        return false, "news filter fail-closed: UTC calendar fields unavailable"
    end
    local nowKey = civilMinuteKey(t.year, t.month, t.day, t.hour, t.min)
    local nextEvent = nil
    for i = 1, #Rt.newsEvents do
        local event = Rt.newsEvents[i]
        local delta = nowKey - event.key
        if delta >= -Cfg.NewsBlockMinutesBefore and delta <= Cfg.NewsBlockMinutesAfter then
            return false, string.format("news blackout: %s @ %s (%+d min; window -%d/+%d)",
                event.label, formatNewsEventUTC(event), delta,
                Cfg.NewsBlockMinutesBefore, Cfg.NewsBlockMinutesAfter)
        end
        if nextEvent == nil and event.key > nowKey then nextEvent = event end
    end
    if nextEvent ~= nil then
        return true, string.format("news clear; next %s @ %s in %d min", nextEvent.label,
            formatNewsEventUTC(nextEvent), nextEvent.key - nowKey)
    end
    if Cfg.NewsRequireFutureEvent then
        return false, "news filter fail-closed: schedule expired; add future UTC events"
    end
    return true, "news clear; no future scheduled events"
end

local function resetIndicatorBuffers()
    Rt.efficiencyWindow = nil
    Ind.emaFast, Ind.emaMed, Ind.emaSlow = {}, {}, {}
    Ind.atr, Ind.plusDI, Ind.minusDI, Ind.adx, Ind.rsi = {}, {}, {}, {}, {}
    Ind.bbWidth = {}
    Ind.vwap, Ind.efficiency, Ind.avgVolume = {}, {}, {}
    Ind.swingHigh, Ind.swingLow = {}, {}
end

local function resetRuntimeState()
    Rt.mlNamespace = nil
    Rt.moneyBudget = nil
    Rt.dailyLossLocked = false
    Rt.stateCandidate, Rt.stateCandidateBars = nil, 0
    Rt.keyLastPeriod, Rt.keySourceFirst = nil, nil
    Rt.indHistoryBackfilled = false
    Rt.lastCopiedPeriod = nil
    Rt.copyRecoveryFrom = nil
    Rt.lastMainClosedSerial = nil
    Rt.lastEntryPeriod = nil
    Rt.lastTradeClosePeriod = nil
    Rt.processingPeriod = nil
    Rt.closedQuoteCache = {}
    Rt.executionQuality = nil
    -- True only after updateMarketContext() has populated Context for the
    -- current processing bar. Close accounting can now run before indicators;
    -- this flag prevents TRADE_CLOSE analytics from borrowing stale prior-bar context.
    Rt.contextReadyForBar = false
    Rt.currentRegime = "NONE"
    Rt.currentBaseRegime = "NONE"
    Rt.regimeBestName, Rt.regimeSecondName = "NONE", "NONE"
    Rt.regimeBestScore, Rt.regimeSecondScore, Rt.regimeConflict = 0, 0, false
    Rt.regimeCompatible = false
    Rt.regimeCompatibleSide = nil
    Rt.regimeCompatibilityText = nil
    Rt.regimeCompetitorName = "NONE"
    Rt.regimeCompetitorScore = 0
    Rt.regimeEffectiveMargin = 0
    Rt.regimeRawMargin = 0
    Rt.lowVolatilityDetected = false
    Rt.lowVolatilityScore = 0
    Rt.lowVolatilityDecision = "NOT_DETECTED"
    Rt.lowVolatilityCandidate = "NONE"
    Rt.lowVolatilityReason = "none"
    Rt.keyLevels = {
        asianHigh=nil, asianLow=nil, asianReady=false, asianKey=nil,
        buildAsianHigh=nil, buildAsianLow=nil, buildAsianKey=nil,
        dayHigh=nil, dayLow=nil, dayKey=nil,
        prevDayHigh=nil, prevDayLow=nil, prevDayReady=false,
        orHigh=nil, orLow=nil, orReady=false, orDayKey=nil, orBars=0,
        lastBarSerial=nil,
    }
    Rt.marketStructure = {
        lastCandidate=nil, lastHigh=nil, previousHigh=nil,
        lastLow=nil, previousLow=nil, events={},
        rawBias="UNKNOWN", bias="UNKNOWN", sequence="NA",
        highAge=nil, lowAge=nil, stale=false, bosUp=false, bosDown=false,
        choch=false, chochDirection="NONE", appliedSide="NONE", appliedWeight=0,
        quality=0, phase="NONE", confidence=0, swingRangeATR=0
    }
    Context, Scores = {}, {}
    Rt.newsEvents = {}
    Rt.newsScheduleOK = false
    Rt.newsScheduleStatus = "not parsed"
    Rt.htfTrend, Rt.htfStrength, Rt.htfLastDate = 0, 0, nil
    Rt.htfGapATR, Rt.htfSlopeATR = 0, 0
    Rt.htfClose, Rt.htfMAValue, Rt.htfATRValue = nil, nil, nil
    Rt.lastHTFPeriod = nil
    Rt.htfStatus = "NO_CALLBACK"
    Rt.htfBarDurationMinutes = nil
    Rt.usedSetupKeys = {}
    Rt.entryStateRestored = false
    Rt.tradeInitialRisk = {}
    Rt.tradeEntryRegime = {}
    Rt.tradeEntryEngine = {}
    Rt.tradeSetupAnchor = {}
    Rt.trailStops = {}
    Rt.tradeRecoveryWarned = {}
    Rt.tradeRiskUnavailable = {}
    Rt.tradeRecovered = {}
    Rt.barIndexFallbackWarned = {}
    Rt.blockedExits = {}
    Rt.pendingOpenRequests = {}
    Rt.pendingUnknownOpen = nil
    Rt.pendingOpenCookies = {}
    Rt.fifoClosePending = {}
    Rt.closePendingTradeIds = {}
    Rt.pendingCloseCookies = {}
    Rt.awaitingCloseReconciliation = {}
    Rt.pendingStopEdits = {}
    Rt.pendingStopEditCookies = {}
    Rt.brokerStopRates = {}
    Rt.stopOrderWarnings = {}
    Rt.tradeMLFeatures = {}
    Rt.tradeExitFeatures = {}
    Rt.tradeLineageRoot = {}
    Rt.cleanPullbackPending = {}
    Rt.cleanPullbackDetails = {}
    Rt.tradeAnalytics = {}
    Rt.lastLoss = nil
    Rt.tradeExitReasons = {}
    Rt.ML = {weights={}, samples=0, wins=0, losses=0, skipped=0,
        exitWeights={}, exitSamples=0, exitWins=0, exitLosses=0, exitSkipped=0,
        recentWins=0, recentLosses=0, recentWindow={},
        calibratedWinRate=0.5, lastProbability=0.5,
        db=nil, storageReady=false, storageName=nil, storageWarning=nil}
    for i = 1, #ML_FEATURE_NAMES do Rt.ML.weights[ML_FEATURE_NAMES[i]] = 0.0 end
    for i = 1, #Const.ML_EXIT_FEATURE_NAMES do Rt.ML.exitWeights[Const.ML_EXIT_FEATURE_NAMES[i]] = 0.0 end
    Rt.nextAsyncCookie = 1000
    Rt.knownClosedTrades = {}
    Rt.closedHistoryInitialized = false
    Rt.consecutiveLosses = 0
    Rt.lossStreakUTCKey = nil
    Rt.sessionKey = nil
    Rt.sessionStartEquity = nil
    Rt.sessionRiskReady = not Cfg.AllowTrade
    Rt.lastMandatorySessionKey = nil
    Rt.lastMandatorySessionClock = nil
    Rt.mandatoryCloseCarryoverDay = nil
    Rt.activeMarketSession = "UNAVAILABLE"
    Rt.activeMarketSessionClock = nil
    Rt.RuntimeDB = nil
    Rt.runtimeStorageReady = false
    Rt.runtimeStorageWarning = nil
    Rt.csvLoggingDisabled = false
    Rt.csvLogErrorReported = false
    Rt.csvStartupDay = nil
    Rt.csvRunId = nil
    Rt.csvConfigId = nil
    resetIndicatorBuffers()
end

local function weekdaySundayZero(year, month, day)
    -- Gregorian weekday, 0=Sunday..6=Saturday (Sakamoto algorithm).
    local t = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4}
    if month < 3 then year = year - 1 end
    return (year + math.floor(year / 4) - math.floor(year / 100) + math.floor(year / 400) + t[month] + day) % 7
end

local function lastSundayOfMonth(year, month)
    local days = ({31,28,31,30,31,30,31,31,30,31,30,31})[month]
    if month == 2 and ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0) then days = 29 end
    return days - weekdaySundayZero(year, month, days)
end

local function isEuropeanSummerTimeUTC(utcDate)
    -- EU DST: from 01:00 UTC on the last Sunday in March until
    -- 01:00 UTC on the last Sunday in October.
    local d = core.dateToTable(utcDate)
    if d.month > 3 and d.month < 10 then return true end
    if d.month < 3 or d.month > 10 then return false end

    local boundaryDay = lastSundayOfMonth(d.year, d.month)
    if d.month == 3 then
        if d.day > boundaryDay then return true end
        if d.day < boundaryDay then return false end
        return d.hour >= 1
    end

    -- October: DST remains active strictly before 01:00 UTC on boundary day.
    if d.day < boundaryDay then return true end
    if d.day > boundaryDay then return false end
    return d.hour < 1
end

local function cetClockForBar(barDate)
    if barDate == nil then return nil, nil end
    local utcDate = core.host:execute("convertTime", core.TZ_EST, core.TZ_UTC, barDate)
    local summer = isEuropeanSummerTimeUTC(utcDate)
    local cetDate = utcDate + ((summer and 2 or 1) / 24.0)
    return cetDate - math.floor(cetDate), summer and "CEST" or "CET"
end

local function isCETLunchBreak(barDate)
    if not Cfg.UseCETLunchBreak then return false, nil, nil end
    local clock, zone = cetClockForBar(barDate)
    if clock == nil then return true, nil, zone end -- fail closed for new entries
    return InRange(clock, Rt.CETLunchStart, Rt.CETLunchEnd), clock, zone
end

local PendingLogMessages = {}

local function terminalReady()
    return terminal ~= nil and terminal.alertMessage ~= nil
end

local function emitTerminalMessage(text)
    if not terminalReady() then
        return false
    end
    local ok = pcall(function()
        terminal:alertMessage(instance.bid:instrument(), instance.bid[NOW], tostring(text), instance.bid:date(NOW))
    end)
    return ok
end

local function queueLog(text)
    PendingLogMessages[#PendingLogMessages + 1] = tostring(text)
    if #PendingLogMessages > 50 then
        table.remove(PendingLogMessages, 1)
    end
end

-- TS2 terminal alerts have a practical message-size ceiling that varies by
-- host build. Keep the complete diagnostic unchanged in CSV, but split only
-- the terminal copy on line boundaries so one oversized BAR alert cannot be
-- silently rejected. A single unusually long line is hard-split as a fallback.
local function splitTerminalDiagnostic(text, maxLength)
    local source = tostring(text or "")
    local limit = tonumber(maxLength) or Const.TERMINAL_DIAGNOSTIC_CHUNK_LENGTH
    if limit < 100 then limit = 100 end
    if string.len(source) <= limit then return {source} end

    local chunks = {}
    local current = ""
    for line in string.gmatch(source .. "\n", "(.-)\n") do
        while string.len(line) > limit do
            if current ~= "" then
                chunks[#chunks + 1] = current
                current = ""
            end
            chunks[#chunks + 1] = string.sub(line, 1, limit)
            line = string.sub(line, limit + 1)
        end

        local candidate = current == "" and line or (current .. "\n" .. line)
        if string.len(candidate) > limit then
            chunks[#chunks + 1] = current
            current = line
        else
            current = candidate
        end
    end
    if current ~= "" then chunks[#chunks + 1] = current end
    return chunks
end

local function emitTerminalDiagnostic(text)
    local chunks = splitTerminalDiagnostic(text, Const.TERMINAL_DIAGNOSTIC_CHUNK_LENGTH)
    for i = 1, #chunks do
        local chunk = "[ARS DIAGNOSTIC " .. tostring(i) .. "/" .. tostring(#chunks) .. "]\n" .. chunks[i]
        if not emitTerminalMessage(chunk) then
            queueLog(chunk)
        end
    end
end

local function flushPendingLogs()
    if not terminalReady() or #PendingLogMessages == 0 then return end
    local pending = PendingLogMessages
    PendingLogMessages = {}
    for i = 1, #pending do
        if not emitTerminalMessage(pending[i]) then
            -- Put the current and remaining messages back if the terminal is not ready yet.
            for j = i, #pending do
                PendingLogMessages[#PendingLogMessages + 1] = pending[j]
            end
            return
        end
    end
end

local function csvEscape(value)
    local text = tostring(value or "")
    return '"' .. string.gsub(text, '"', '""') .. '"'
end

local function csvTimestampUTC(dateValue)
    local value = dateValue
    -- BAR rows pass their exact closed-candle time. Operational/async rows use
    -- the host's current simulated/live quote time instead of a stale bar index.
    if value == nil and instance ~= nil and instance.bid ~= nil then
        local okDate, currentDate = pcall(function() return instance.bid:date(NOW) end)
        if okDate then value = currentDate end
    end
    if not validNumber(value) then return "" end

    local okUTC, utcDate = pcall(function()
        return core.host:execute("convertTime", core.TZ_EST, core.TZ_UTC, value)
    end)
    if not okUTC or not validNumber(utcDate) then return "" end
    local okTable, t = pcall(function() return core.dateToTable(utcDate) end)
    if not okTable or type(t) ~= "table" then return "" end
    local second = tonumber(t.sec or t.second) or 0
    return string.format("%04d-%02d-%02d %02d:%02d:%02d",
        tonumber(t.year) or 0, tonumber(t.month) or 0, tonumber(t.day) or 0,
        tonumber(t.hour) or 0, tonumber(t.min) or 0, second)
end

local function reportCSVLogFailure(problem)
    Rt.csvLoggingDisabled = true
    if Rt.csvLogErrorReported then return end
    Rt.csvLogErrorReported = true
    local text = "CSV LOG DISABLED: " .. tostring(problem)
    if not emitTerminalMessage(text) then queueLog(text) end
end

local function csvSafeFilePart(value)
    local text = tostring(value or "")
    text = string.gsub(text, "[^%w%._%-]", "_")
    text = string.gsub(text, "_+", "_")
    text = string.gsub(text, "^_+", "")
    text = string.gsub(text, "_+$", "")
    if text == "" then return "UNKNOWN" end
    return text
end

local function dailyCSVLogPath(timestampUTC)
    local configured = trimText(Cfg.CSVLogFile)
    if configured == "" then return nil, "CSV Log File is empty" end
    if type(timestampUTC) ~= "string" or string.len(timestampUTC) < 10 then
        return nil, "UTC date is unavailable"
    end

    -- CSV Log File acts as the destination folder selector. A legacy .csv
    -- value keeps only its directory; a folder value may end with or without
    -- a slash. The generated filename is always instrument/timeframe/UTC day.
    local directory = ""
    local lower = string.lower(configured)
    if string.sub(lower, -4) == ".csv" then
        for i = string.len(configured), 1, -1 do
            local ch = string.sub(configured, i, i)
            if ch == "\\" or ch == "/" then
                directory = string.sub(configured, 1, i)
                break
            end
        end
    else
        directory = configured
        local last = string.sub(directory, -1)
        if last ~= "\\" and last ~= "/" then
            local separator = string.find(directory, "\\", 1, true) ~= nil and "\\" or "/"
            directory = directory .. separator
        end
    end

    local instrument = "UNKNOWN"
    if instance ~= nil and instance.bid ~= nil then
        local okInstrument, value = pcall(function() return instance.bid:instrument() end)
        if okInstrument then instrument = csvSafeFilePart(value) end
    end
    local timeframe = string.upper(csvSafeFilePart(Cfg.TF))
    local utcDay = string.sub(timestampUTC, 1, 10)
    return directory .. instrument .. "_" .. timeframe .. "_" .. utcDay .. ".csv", nil
end

local function writeCSVLog(eventType, message, dateValue)
    if not Cfg.WriteCSVLogFile or Rt.csvLoggingDisabled then return false end
    local timestampUTC = csvTimestampUTC(dateValue)
    if timestampUTC == "" then
        -- Prepare can run before TS2 exposes a simulated/live quote time.
        -- Defer the row; the first closed main bar starts the dated log.
        return false
    end
    local path, pathError = dailyCSVLogPath(timestampUTC)
    if path == nil then
        reportCSVLogFailure(pathError)
        return false
    end
    if type(io) ~= "table" or type(io.open) ~= "function" then
        reportCSVLogFailure("Lua file I/O is unavailable in this host")
        return false
    end

    local ok, problem = pcall(function()
        -- Open and close on every event so a stopped backtest cannot strand a
        -- buffered handle or lose the final diagnostic rows.
        local file, openError = io.open(path, "a+")
        if file == nil then error(openError or "unable to open file") end
        local size, seekError = file:seek("end")
        if size == nil then
            file:close()
            error(seekError or "unable to inspect file")
        end
        if size == 0 then
            local headerOK, headerError = file:write(
                "timestamp_utc,event_type,instrument,timeframe,custom_id,message\r\n")
            if headerOK == nil then
                file:close()
                error(headerError or "unable to write CSV header")
            end
        end

        local instrument = ""
        if instance ~= nil and instance.bid ~= nil then
            local okInstrument, value = pcall(function() return instance.bid:instrument() end)
            if okInstrument then instrument = tostring(value or "") end
        end
        local csvMessage = tostring(message or "")
        if Rt.csvRunId ~= nil and Rt.csvRunId ~= "" then
            csvMessage = csvMessage .. "|run_id=" .. tostring(Rt.csvRunId)
        end
        local row = table.concat({
            csvEscape(timestampUTC),
            csvEscape(eventType),
            csvEscape(instrument),
            csvEscape(Cfg.TF),
            csvEscape(Cfg.CustomID),
            csvEscape(csvMessage)
        }, ",") .. "\r\n"
        local writeOK, writeError = file:write(row)
        if writeOK == nil then
            file:close()
            error(writeError or "unable to write CSV row")
        end
        local flushOK, flushError = pcall(function() file:flush() end)
        -- Some TS2/Indicore Lua hosts return nil from a successful close.
        -- Treat only a thrown close exception as failure; the return value is
        -- not portable across the Lua runtimes embedded by TS2 versions.
        local closeOK, closeError = pcall(function() file:close() end)
        if not flushOK then error(flushError or "unable to flush CSV row") end
        if not closeOK then error(closeError or "unable to close CSV file") end
    end)
    if not ok then
        reportCSVLogFailure(path .. " | " .. tostring(problem))
        return false
    end
    return true
end

local function debug(msg)
    if not Cfg.ShowDebug then return end
    local text = tostring(STRATEGY_NAME) .. " | " .. tostring(msg)
    writeCSVLog("DEBUG", text, nil)
    if not emitTerminalMessage(text) then
        queueLog(text)
    end
end

local function alert(msg)
    if not Cfg.ShowAlerts then return end
    local text = tostring(msg)
    writeCSVLog("ALERT", text, nil)
    if not emitTerminalMessage(text) then
        queueLog(text)
    end
end

local function sourcePipSize()
    return Rt.Source:pipSize()
end

local function closedStreamPrice(stream, p)
    if stream == nil or p == nil or Rt.Source == nil then return nil end
    local idx = p
    if stream ~= Rt.Source then
        idx = core.findDate(stream, Rt.Source:date(p), true)
        if idx == -1 then return nil end
        -- findDate may return a preceding bar. Never combine different candles
        -- into an apparently valid spread when the opposite stream is delayed.
        local matchedDate = stream:date(idx)
        local wantedDate = Rt.Source:date(p)
        if not validNumber(matchedDate) or not validNumber(wantedDate)
            or abs(matchedDate - wantedDate) > 0.000000001 then return nil end
    end
    if stream.close == nil or not stream.close:hasData(idx) then return nil end
    local value = stream.close[idx]
    return validNumber(value) and value or nil
end

local function closedBidAsk(p)
    Rt.closedQuoteCache = Rt.closedQuoteCache or {}
    local result = Rt.closedQuoteCache[p]
    if result == nil then
        result = {bid=closedStreamPrice(Rt.BidSource, p), ask=closedStreamPrice(Rt.AskSource, p)}
        Rt.closedQuoteCache[p] = result
    end
    return result.bid, result.ask
end

local function spreadPips(p)
    local bid, ask
    if p ~= nil then
        bid, ask = closedBidAsk(p)
    else
        bid, ask = instance.bid[NOW], instance.ask[NOW]
    end
    if not validNumber(bid) or not validNumber(ask) or ask < bid then return 999999 end
    local pip = instance.bid:pipSize()
    if not validNumber(pip) or pip <= 0 then return 999999 end
    return (ask - bid) / pip
end

-- Closed-candle execution quality, not tick/order-flow microstructure.
-- The reference average uses PRIOR bars only. Optional FILTER adds entry-only
-- cost gates; OBSERVE (default) records evidence without changing permissions.
function Rt.executionCostStatus(spread, atr, reference, samples)
    if not validNumber(spread) or spread < 0 or spread >= 999999 then
        return false, "bid/ask unavailable or crossed", nil, nil
    end
    local pip = sourcePipSize()
    if not validNumber(atr) or atr <= 0 or not validNumber(pip) or pip <= 0 then
        return false, "ATR/pip data unavailable", nil, nil
    end
    local fraction = spread * pip / atr
    local ratio = reference ~= nil and reference > 0 and spread / reference or nil
    if fraction > (Cfg.ExecutionMaxSpreadATR or 0.30) then
        return false, "spread exceeds ATR cost limit", fraction, ratio
    end
    if (samples or 0) >= (Cfg.ExecutionMinSamples or 10) and ratio ~= nil
        and ratio > (Cfg.ExecutionMaxSpreadRatio or 2.0) then
        return false, "spread elevated vs prior bars", fraction, ratio
    end
    return true, (samples or 0) < (Cfg.ExecutionMinSamples or 10)
        and "cost OK; spread baseline warming" or "cost OK", fraction, ratio
end

function Rt.updateExecutionQuality(p)
    Rt.executionQuality = nil
    if Cfg.ExecutionQualityMode == "OFF" then return end
    local sum, count = 0, 0
    local first = max(Rt.Source:first(), p - (Cfg.ExecutionLookback or 30))
    for i = first, p - 1 do
        local value = spreadPips(i)
        if validNumber(value) and value >= 0 and value < 999999 then
            sum, count = sum + value, count + 1
        end
    end
    local reference = count > 0 and sum / count or nil
    local spread = spreadPips(p)
    local ok, reason, fraction, ratio = Rt.executionCostStatus(spread, Context.atr, reference, count)
    Rt.executionQuality = {period=p, ok=ok, reason=reason, spread=spread,
        reference=reference, samples=count, fraction=fraction, ratio=ratio}
end

function Rt.executionQualityText()
    local q = Rt.executionQuality
    if q == nil then return "EXECUTION QUALITY | OFF / unavailable" end
    return string.format("EXECUTION QUALITY | %s | %s | closeSpread=%.2fp | spreadATR=%s | priorMean=%s | ratio=%s | samples=%d | closed-bar samples only",
        tostring(Cfg.ExecutionQualityMode), q.reason, q.spread,
        q.fraction and string.format("%.3f", q.fraction) or "NA",
        q.reference and string.format("%.2fp", q.reference) or "NA",
        q.ratio and string.format("%.2fx", q.ratio) or "NA", q.samples)
end

local function getAccountEquity()
    if Rt.Account == nil or Rt.Account == "" then return nil end
    -- Guarded so an unready/missing "accounts" table degrades to nil instead
    -- of raising an uncaught error. This function is called from several
    -- places (checkRiskLimits, trailingDiagnostic, calculatePositionSize)
    -- that are not themselves wrapped in pcall, unlike refreshClosedTradeLosses.
    local ok, result = pcall(function()
        local row = core.host:findTable("accounts"):find("AccountID", Rt.Account)
        if row == nil then return nil end
        return tonumber(row.Equity)
    end)
    if not ok or not validNumber(result) then return nil end
    return result
end

local function getAccountBalance()
    if Rt.Account == nil or Rt.Account == "" then return nil end
    local ok, result = pcall(function()
        local accounts = core.host:findTable("accounts")
        if accounts == nil then return nil end
        local row = accounts:find("AccountID", Rt.Account)
        if row == nil then return nil end
        return tonumber(row.Balance)
    end)
    if not ok or not validNumber(result) then return nil end
    return result
end

local function allocateAsyncCookie()
    local cookie = Rt.nextAsyncCookie
    Rt.nextAsyncCookie = Rt.nextAsyncCookie + 1
    if Rt.nextAsyncCookie > 2000000000 then Rt.nextAsyncCookie = 1000 end
    return cookie
end

local function subscribeBars(id, timeframe, historyCount, bidOrAsk)
    -- Newer helper.lua versions expose ExtSubscribe1 with an explicit history
    -- count. Older Strategy Builder installations expose ExtSubscribe only.
    -- Prefer the history-aware form, but remain loadable on either helper.
    if type(ExtSubscribe1) == "function" then
        return ExtSubscribe1(id, nil, timeframe, historyCount, bidOrAsk, "bar")
    end
    assert(type(ExtSubscribe) == "function", "FXCM strategy helper exposes neither ExtSubscribe1 nor ExtSubscribe")
    return ExtSubscribe(id, nil, timeframe, bidOrAsk, "bar")
end

local function getDayKey(dateValue)
    -- Daily risk limits follow the operator-selected session timezone.
    local sessionDate = core.host:execute("convertTime", core.TZ_EST, Rt.ToTime, dateValue)
    local t = core.dateToTable(sessionDate)
    return string.format("%04d-%02d-%02d", t.year, t.month, t.day)
end

local function getUTCDayKey(dateValue)
    -- FXTS price/table dates are EST; convert explicitly so the loss-streak
    -- boundary is always 00:00 UTC regardless of the selected session zone.
    local utcDate = core.host:execute("convertTime", core.TZ_EST, core.TZ_UTC, dateValue)
    local t = core.dateToTable(utcDate)
    return string.format("%04d-%02d-%02d", t.year, t.month, t.day)
end

-- =========================
-- Local ML meta-filter; namespace changes only when the entry distribution changes.
-- =========================
local function stableTextHash(text)
    local hash = 7
    for i = 1, #text do hash = (hash * 131 + string.byte(text, i)) % 2147483647 end
    return tostring(hash)
end

-- Defined after the shared checksum-backed file database implementation.
-- Forward declaration lets optional ML persistence use the same fallback when
-- this FXTS2 installation does not ship the non-standard storagedb module.
local openFileStateDB

local function mlStorageName()
    if Rt.mlNamespace ~= nil then return Rt.mlNamespace end
    -- Include every deterministic entry-distribution input. A model trained
    -- under different rules must never be silently reused by another run.
    local configText = table.concat({
        tostring(Cfg.ActivityIdentity), tostring(Cfg.FixedLotRiskGuard),
        Cfg.MaxOpenRiskPct, Cfg.RiskSlippagePips, Cfg.RoundTripCommissionPerLot,
        Cfg.MinNetRewardRisk, Cfg.SmartStateMaxHoldBars,
        Cfg.MAMethod, Cfg.FastPeriod, Cfg.MediumPeriod, Cfg.SlowPeriod,
        Cfg.RSIPeriod, Cfg.ATRPeriod, Cfg.ADXPeriod, Cfg.BBPeriod,
        Cfg.SwingPeriod, Cfg.StatsPeriod, Cfg.MomentumPeriod,
        Cfg.StructurePivotStrength, Cfg.StructureMinPivotATR, tostring(Cfg.UseEnhancedStructure), tostring(Cfg.UseStructureDirectionWeight),
        Cfg.StructureDirectionWeight, Cfg.StructureMaxPivotAgeBars,
        Cfg.RegimeThreshold, Cfg.ReversalThreshold, Cfg.RegimeConfidenceMargin,
        Cfg.TrendBreakoutConfidenceBonus, Cfg.ProbabilityScoreMin,
        tostring(Cfg.AllowTrendTrades), tostring(Cfg.AllowBreakoutTrades),
        tostring(Cfg.AllowRangeTrades), tostring(Cfg.AllowReversalTrades), tostring(Cfg.OnlyEMAPullbacks),
        tostring(Cfg.RequireDominantDirectionalRegime), Cfg.MinimumTrendADX,
        tostring(Cfg.RequireDirectionalDMIAlignment),
        Cfg.ProbabilityEdgeMin, tostring(Cfg.ProbabilityRequireHTFData),
        tostring(Cfg.UseSmartEvidence), tostring(Cfg.RequireEvidenceCoherence),
        Cfg.MinBucketDirection, Cfg.MinBucketStructure, Cfg.MinBucketLocation,
        Cfg.MinBucketMomentum, Cfg.SmartHTFOpposedScoreAdd, Cfg.SmartHTFOpposedEdgeAdd,
        Cfg.SmartThinMarginScoreAdd, Cfg.SmartHighVolScoreAdd, Cfg.SmartAgreementBonusMax,
        Cfg.VWAPStretchATR, Cfg.TrendMaxExtensionATR, Cfg.TrendEntryMode,
        Cfg.PullbackMinRetraceATR, Cfg.PullbackMaxAgeBars, Cfg.PullbackMinReclaimATR, Cfg.PullbackMinBodyATR, Cfg.PullbackMaxAdverseATR, Cfg.PullbackMaxVWAPATR, Cfg.PullbackMaxLongRSI, Cfg.PullbackMinShortRSI,
        Cfg.TrendPullbackLookbackBars, Cfg.TrendPullbackTouchATR,
        Cfg.TrendPullbackMaxCloseATR, Cfg.ProbabilityPullbackMaxEntryGapATR,
        Cfg.CleanPullbackRetestLookbackBars, Cfg.CleanPullbackTouchATR,
        Cfg.CleanPullbackReclaimATR, Cfg.CleanPullbackVWAPPenaltyATR,
        Cfg.CleanPullbackMaxVWAPStretchATR, Cfg.CleanPullbackVWAPPenaltyScore,
        tostring(Cfg.UseEarlyTrendBreakout),
        Cfg.EarlyBreakoutMinMomentumATR, Cfg.EarlyBreakoutMinDMIRatio,
        Cfg.EarlyBreakoutMinADX, Cfg.EarlyBreakoutMaxFastMAGapATR,
        Cfg.EarlyBreakoutMaxVWAPExtensionATR, Cfg.BreakoutMaxExtensionATR,
        Cfg.RangeEdgeFraction, Cfg.BreakoutATRMin, Cfg.BreakoutCompressionLookback,
        Cfg.CompressionATRPctMax, Cfg.CompressionBBPctMax,
        Cfg.CompressionRangeATRMax, Cfg.LargeCandleATR,
        tostring(Cfg.UseVolumeFilter), Cfg.VolumeLookback, Cfg.VolumeFactor,
        Cfg.MaxSpreadPips, tostring(Cfg.BlockEntriesFarFromVWAP), Cfg.MaxEntryVWAPDistanceATR,
        tostring(Cfg.UseHTF), Cfg.HTF, Cfg.HTFMAMethod, Cfg.HTFMAPeriod,
        Cfg.HTFATRPeriod, Cfg.HTFMaxAgeMinutes, Cfg.HTFOppositionMinGapATR,
        Cfg.HTFOppositionMinSlopeATR, tostring(Cfg.HTFAllowNeutral),
        tostring(Cfg.HTFOppositionMode), tostring(Cfg.OpposingCHOCHHardBlock),
        tostring(Cfg.UseGlobalSessionFilter), tostring(Cfg.TradeSydney),
        tostring(Cfg.TradeSydneyTokyoOverlap), tostring(Cfg.TradeTokyo),
        tostring(Cfg.TradeTokyoLondonOverlap), tostring(Cfg.TradeLondon),
        tostring(Cfg.TradeLondonNewYorkOverlap), tostring(Cfg.TradeNewYork),
        tostring(Cfg.TradeOffHours), tostring(Rt.OpenTime), tostring(Rt.CloseTime),
        tostring(Rt.SydneyOpen), tostring(Rt.SydneyClose),
        tostring(Rt.TokyoOpen), tostring(Rt.TokyoClose),
        tostring(Rt.LondonOpen), tostring(Rt.LondonClose),
        tostring(Rt.NewYorkOpen), tostring(Rt.NewYorkClose),
        tostring(Cfg.UseCETLunchBreak), tostring(Rt.CETLunchStart),
        tostring(Rt.CETLunchEnd), tostring(Cfg.UseNewsFilter),
        Cfg.NewsEventScheduleUTC, Cfg.NewsBlockMinutesBefore,
        Cfg.NewsBlockMinutesAfter, tostring(Cfg.NewsRequireFutureEvent),
        Cfg.ATRStopTrend, Cfg.ATRStopRange, Cfg.ATRStopBreakout,
        Cfg.ATRStopReversal, Cfg.VolatilityLookback, tostring(Cfg.UseVolatilityStopWidening),
        Cfg.VolWidenStartPct, Cfg.VolWidenFullPct, Cfg.VolWidenMax,
        tostring(Cfg.FixedStopVolatilityPolicy), Cfg.MaxEntryStopPips,
        Cfg.VolRiskP25, Cfg.VolRiskP50, Cfg.VolRiskP60, Cfg.VolRiskP70, Cfg.VolRiskP80, Cfg.VolRiskP90, Cfg.VolRiskP100,
        tostring(Cfg.UseRangeStopWidthGate), Cfg.MaxRangeStopFraction,
        Cfg.RRTrend, Cfg.RRRange, Cfg.RRBreakout,
        Cfg.RRReversal, Cfg.BreakEvenR, Cfg.TrailATR, Cfg.MaxBarsInTrade,
        tostring(Cfg.SetStop), Cfg.Stop, tostring(Cfg.SetLimit), Cfg.Limit,
        -- OBSERVE/FILTER/OFF controls whether learning is consulted, not the
        -- feature distribution or learned weights; keep one model across modes.
        tostring(Cfg.TrailingStop), Cfg.MLMinSamples,
        Cfg.MLProbabilityThreshold, tostring(Cfg.MLAdaptiveThreshold),
        Cfg.MLRecentWindow, tostring(Cfg.MLWeightByR),
        Cfg.MLLearningRate, Cfg.MLL2, Cfg.MLMaxAbsWeight,
        tostring(Cfg.MLBalanceClasses),
        tostring(Cfg.MLPersistModel), Cfg.AllowedSide,
        tostring(Cfg.AllowMultiple), tostring(Cfg.OneTradePerDirection),
        Cfg.MaxPositions, Cfg.MinBarsBetweenTrades, Cfg.SetupResetBars,
        Cfg.PendingOpenTimeoutBars, Cfg.PendingCloseTimeoutBars,
        Cfg.MaxDailyLossPct, Cfg.MaxConsecutiveLosses,
        tostring(Cfg.BreakEvenResetsLossStreak)
    }, "|")
    -- These exit settings change the outcome labels observed by Smart AI.
    -- Preserve the old namespace only when both retain the previous ON
    -- behavior; a disabled exit policy gets its own demo/live model group.
    if Cfg.ExitOnRegimeFlip ~= true or Cfg.ExitOnThesisInvalidation ~= true then
        configText = configText .. "|EXIT_POLICY|" .. tostring(Cfg.ExitOnRegimeFlip == true)
            .. "|" .. tostring(Cfg.ExitOnThesisInvalidation == true)
    end
    -- Shared demo/live training must use one account-independent namespace.
    -- Keep the model group in the identity; when sharing is off, retain the
    -- account scope so demo and live models remain isolated by default.
    local modelScope
    local modelLabel
    if Cfg.MLShareAcrossAccounts then
        modelScope = "SHARED_GROUP:" .. tostring(Cfg.MLModelGroup or "")
        modelLabel = Cfg.MLModelGroup
    else
        modelScope = "ACCOUNT:" .. tostring(Cfg.CustomID or "NA") .. "|" .. tostring(Rt.Account or "NA")
        modelLabel = Cfg.CustomID
    end
    -- A shared demo/live model must not depend on the account-specific CustomID.
    -- Ownership stays isolated by CustomID in trade-management paths; this key
    -- is only for the learned model on this local FXTS installation.
    local identity = table.concat({modelScope,
        tostring(instance.bid:instrument() or "NA"), tostring(Cfg.TF or "NA"), configText}, "|")
    -- New entry populations learn independently; CLASSIC retains its prior
    -- entry and exit model namespace. Runtime trade ownership stays stable.
    if Cfg.CleanPullbackMode == "UPGRADED" and (Cfg.EntryEngineMode == "CLEAN"
        or Cfg.EntryEngineMode == "SHADOW" or Cfg.EntryEngineMode == "HYBRID_CONFIRM") then
        identity = identity .. "|CLEAN_PULLBACK_V1|" .. table.concat({
            Cfg.CleanPullbackMinScore, Cfg.CleanPullbackMinSlopeATR,
            Cfg.CleanPullbackMaxAdverseATR, Cfg.CleanMinDMIRatio,
            Cfg.CleanTriggerBodyATR, Cfg.CleanTriggerCloseLoc,
            Cfg.CleanPullbackMaxFastGapATR, Cfg.CleanPullbackStateMaxCounterMomentumATR,
            Cfg.CleanPullbackMinDMIRatio, tostring(Cfg.CleanUseVWAPQuality),
            Cfg.CleanVWAPAlignedBonus, Cfg.CleanVWAPOpposedPenalty,
            Cfg.CleanMinEntryScore}, "|")
        if Cfg.EntryEngineMode == "HYBRID_CONFIRM" then
            identity = identity .. "|HYBRID_CONFIRM|" .. table.concat({
                Cfg.LegacyV2TrendMinEvidence, Cfg.LegacyV2MinDirection,
                Cfg.LegacyV2MinStructure, Cfg.LegacyV2MinLocation, Cfg.LegacyV2MinMomentum,
                Cfg.LegacyV2SmartStatePolicy, Cfg.LegacyV2StrictMinConfidence,
                Cfg.LegacyV2SmartStateBonus}, "|")
        end
    end
    -- OBSERVE/OFF do not change eligible trades, so keep the existing model
    -- namespace and preserve accumulated demo learning. Enforced quality rules
    -- change the entry population; isolate that model by the active thresholds.
    if Cfg.EntryQualityMode == "ENFORCE" then
        identity = identity .. "|ENTRY_QUALITY_ENFORCE|" .. table.concat({
            Cfg.EntryMinBodyATR, Cfg.EntryMinCloseLoc, Cfg.EntryMaxBodyATR,
            tostring(Cfg.EntryRequireBreakPriorBar), Cfg.EntryMinRoomATR,
            Cfg.EntryRoomLookback, Cfg.EntryMaxSpreadStopRatio,
            Cfg.EntryMaxRSILong, Cfg.EntryMinRSIShort, Cfg.EntryMinEfficiency,
            Cfg.EntryFastLossBars, Cfg.EntryFastLossLockBars
        }, "|")
    end
    local label = string.sub(string.gsub(tostring(modelLabel or "NA"), "[^%w_]", "_"), 1, 24)
    Rt.mlNamespace = "ARSML_V4_" .. label .. "_" .. stableTextHash(identity)
    return Rt.mlNamespace
end

local function csvConfigurationId()
    local identity = table.concat({
        tostring(Cfg.ActivityIdentity), tostring(Cfg.FixedLotRiskGuard),
        Cfg.MaxOpenRiskPct, Cfg.RiskSlippagePips, Cfg.RoundTripCommissionPerLot,
        Cfg.MinNetRewardRisk, Cfg.SmartStateMaxHoldBars,
        STRATEGY_VERSION, Cfg.CustomID, Cfg.TF, tostring(Cfg.HTF),
        tostring(Cfg.ExitOnRegimeFlip), tostring(Cfg.ExitOnThesisInvalidation),
        Cfg.MAMethod, Cfg.FastPeriod, Cfg.MediumPeriod, Cfg.SlowPeriod,
        Cfg.ATRPeriod, Cfg.ADXPeriod, Cfg.RSIPeriod, Cfg.BBPeriod,
        Cfg.StatsPeriod, Cfg.SwingPeriod, Cfg.MomentumPeriod,
        Cfg.RegimeThreshold, Cfg.ReversalThreshold, Cfg.RegimeConfidenceMargin,
        Cfg.TrendBreakoutConfidenceBonus, Cfg.ProbabilityScoreMin,
        tostring(Cfg.AllowTrendTrades), tostring(Cfg.AllowBreakoutTrades),
        tostring(Cfg.AllowRangeTrades), tostring(Cfg.AllowReversalTrades), tostring(Cfg.OnlyEMAPullbacks),
        tostring(Cfg.RequireDominantDirectionalRegime), Cfg.MinimumTrendADX,
        tostring(Cfg.RequireDirectionalDMIAlignment),
        Cfg.ProbabilityEdgeMin, tostring(Cfg.ProbabilityRequireHTFData),
        tostring(Cfg.UseSmartEvidence), tostring(Cfg.RequireEvidenceCoherence),
        Cfg.MinBucketDirection, Cfg.MinBucketStructure, Cfg.MinBucketLocation,
        Cfg.MinBucketMomentum, Cfg.SmartHTFOpposedScoreAdd, Cfg.SmartHTFOpposedEdgeAdd,
        Cfg.SmartThinMarginScoreAdd, Cfg.SmartHighVolScoreAdd, Cfg.SmartAgreementBonusMax,
        Cfg.TrendEntryMode, Cfg.PullbackMinRetraceATR, Cfg.PullbackMaxAgeBars, Cfg.PullbackMinReclaimATR, Cfg.PullbackMinBodyATR, Cfg.PullbackMaxAdverseATR, Cfg.PullbackMaxVWAPATR, Cfg.PullbackMaxLongRSI, Cfg.PullbackMinShortRSI,
        Cfg.TrendPullbackLookbackBars,
        Cfg.TrendPullbackTouchATR, Cfg.TrendPullbackMaxCloseATR,
        Cfg.CleanPullbackRetestLookbackBars, Cfg.CleanPullbackTouchATR,
        Cfg.CleanPullbackReclaimATR, Cfg.CleanPullbackVWAPPenaltyATR,
        Cfg.CleanPullbackMaxVWAPStretchATR, Cfg.CleanPullbackVWAPPenaltyScore,
        Cfg.ProbabilityPullbackMaxEntryGapATR, Cfg.VWAPStretchATR,
        Cfg.TrendMaxExtensionATR, tostring(Cfg.UseEarlyTrendBreakout),
        Cfg.EarlyBreakoutMinMomentumATR, Cfg.EarlyBreakoutMinDMIRatio,
        Cfg.EarlyBreakoutMinADX, Cfg.EarlyBreakoutMaxFastMAGapATR,
        Cfg.EarlyBreakoutMaxVWAPExtensionATR, Cfg.BreakoutMaxExtensionATR,
        Cfg.RangeEdgeFraction, Cfg.BreakoutATRMin,
        Cfg.BreakoutCompressionLookback, Cfg.CompressionATRPctMax,
        Cfg.CompressionBBPctMax, Cfg.CompressionRangeATRMax,
        Cfg.LargeCandleATR, tostring(Cfg.UseStructureDirectionWeight),
        Cfg.StructurePivotStrength, Cfg.StructureMinPivotATR, tostring(Cfg.UseEnhancedStructure), Cfg.StructureDirectionWeight,
        Cfg.StructureMaxPivotAgeBars, tostring(Cfg.UseVolumeFilter),
        Cfg.VolumeLookback, Cfg.VolumeFactor, Cfg.MaxSpreadPips,
        tostring(Cfg.BlockEntriesFarFromVWAP), Cfg.MaxEntryVWAPDistanceATR,
        tostring(Cfg.UseHTF),
        Cfg.HTFMaxAgeMinutes, Cfg.HTFMAMethod, Cfg.HTFMAPeriod,
        Cfg.HTFATRPeriod, Cfg.HTFOppositionMinGapATR,
        Cfg.HTFOppositionMinSlopeATR, tostring(Cfg.HTFAllowNeutral),
        tostring(Cfg.HTFOppositionMode), tostring(Cfg.OpposingCHOCHHardBlock),
        tostring(Cfg.UseGlobalSessionFilter), tostring(Cfg.TradeSydney),
        tostring(Cfg.TradeSydneyTokyoOverlap), tostring(Cfg.TradeTokyo),
        tostring(Cfg.TradeTokyoLondonOverlap), tostring(Cfg.TradeLondon),
        tostring(Cfg.TradeLondonNewYorkOverlap), tostring(Cfg.TradeNewYork),
        tostring(Cfg.TradeOffHours), tostring(Rt.OpenTime), tostring(Rt.CloseTime),
        tostring(Rt.SydneyOpen), tostring(Rt.SydneyClose),
        tostring(Rt.TokyoOpen), tostring(Rt.TokyoClose),
        tostring(Rt.LondonOpen), tostring(Rt.LondonClose),
        tostring(Rt.NewYorkOpen), tostring(Rt.NewYorkClose),
        tostring(Cfg.UseCETLunchBreak), tostring(Rt.CETLunchStart),
        tostring(Rt.CETLunchEnd), tostring(Cfg.UseNewsFilter),
        Cfg.NewsEventScheduleUTC, Cfg.NewsBlockMinutesBefore,
        Cfg.NewsBlockMinutesAfter, tostring(Cfg.NewsRequireFutureEvent),
        Cfg.SizingMode, Cfg.Amount, Cfg.RiskPct, Cfg.PipValueMode, Cfg.PipValuePerBaseUnit,
        Cfg.ATRStopTrend, Cfg.ATRStopRange, Cfg.ATRStopBreakout,
        Cfg.ATRStopReversal, Cfg.VolatilityLookback, tostring(Cfg.UseVolatilityStopWidening),
        Cfg.VolWidenStartPct, Cfg.VolWidenFullPct, Cfg.VolWidenMax,
        tostring(Cfg.FixedStopVolatilityPolicy), Cfg.MaxEntryStopPips,
        Cfg.VolRiskP25, Cfg.VolRiskP50, Cfg.VolRiskP60, Cfg.VolRiskP70, Cfg.VolRiskP80, Cfg.VolRiskP90, Cfg.VolRiskP100,
        tostring(Cfg.UseRangeStopWidthGate), Cfg.MaxRangeStopFraction,
        Cfg.RRTrend, Cfg.RRRange, Cfg.RRBreakout,
        Cfg.RRReversal, Cfg.BreakEvenR, Cfg.TrailATR, Cfg.MaxBarsInTrade,
        tostring(Cfg.SetStop), Cfg.Stop, tostring(Cfg.SetLimit), Cfg.Limit,
        tostring(Cfg.TrailingStop), Cfg.AllowedSide,
        tostring(Cfg.AllowMultiple), tostring(Cfg.OneTradePerDirection),
        Cfg.MaxPositions, Cfg.MinBarsBetweenTrades, Cfg.SetupResetBars,
        Cfg.PendingOpenTimeoutBars, Cfg.PendingCloseTimeoutBars,
        Cfg.MaxUnits, Cfg.MaxTotalUnits, Cfg.MinLots, Cfg.MaxLots,
        Cfg.MaxDailyLossPct, Cfg.MaxConsecutiveLosses, tostring(Cfg.BreakEvenResetsLossStreak),
        tostring(Cfg.UseMandatoryClose), tostring(Rt.MandatoryCloseTime),
        Cfg.ExecutionQualityMode, Cfg.ExecutionLookback, Cfg.ExecutionMinSamples,
        Cfg.ExecutionMaxSpreadATR, Cfg.ExecutionMaxSpreadRatio,
        Cfg.MLMode, Cfg.MLMinSamples, Cfg.MLProbabilityThreshold,
        tostring(Cfg.MLAdaptiveThreshold), Cfg.MLRecentWindow, tostring(Cfg.MLWeightByR),
        Cfg.MLLearningRate, Cfg.MLL2, Cfg.MLMaxAbsWeight,
        tostring(Cfg.MLBalanceClasses), tostring(Cfg.MLPersistModel),
        Cfg.EntryQualityMode, Cfg.EntryMinBodyATR, Cfg.EntryMinCloseLoc,
        Cfg.EntryMaxBodyATR, tostring(Cfg.EntryRequireBreakPriorBar),
        Cfg.EntryMinRoomATR, Cfg.EntryRoomLookback, Cfg.EntryMaxSpreadStopRatio,
        Cfg.EntryMaxRSILong, Cfg.EntryMinRSIShort, Cfg.EntryMinEfficiency,
        Cfg.EntryFastLossBars, Cfg.EntryFastLossLockBars
    }, "|")
    identity = identity .. "|CLEAN_PULLBACK|" .. table.concat({
        tostring(Cfg.CleanPullbackMode), tostring(Cfg.CleanPullbackMinScore),
        tostring(Cfg.CleanPullbackMinSlopeATR), tostring(Cfg.CleanPullbackMaxAdverseATR)}, "|")
    return stableTextHash(identity)
end

local function mlStoredCount(db, name)
    local value = tonumber(db:get(name, "0"))
    if not validNumber(value) or value < 0 then return 0 end
    -- Counters are written as integers. Flooring a damaged fractional value
    -- is deterministic and prevents %d diagnostics/class weights from failing.
    return math.floor(value)
end

local function mlPersistState()
    if Rt.ML == nil or not Cfg.MLPersistModel or not Rt.ML.storageReady or Rt.ML.db == nil then return false end
    Rt.ML.exitWeights = Rt.ML.exitWeights or {}
    local ok, err = pcall(function()
        Rt.ML.db:put("modelVersion", "4")
        Rt.ML.db:put("samples", tostring(Rt.ML.samples or 0))
        Rt.ML.db:put("wins", tostring(Rt.ML.wins or 0))
        Rt.ML.db:put("losses", tostring(Rt.ML.losses or 0))
        Rt.ML.db:put("skipped", tostring(Rt.ML.skipped or 0))
        Rt.ML.db:put("calibratedWinRate", string.format("%.17g", Rt.ML.calibratedWinRate or 0.5))
        for i = 1, #ML_FEATURE_NAMES do
            local name = ML_FEATURE_NAMES[i]
            Rt.ML.db:put("w_" .. name, string.format("%.17g", Rt.ML.weights[name] or 0.0))
        end
        -- Additive model segment: the entry learner and its ARSML_V4 weights
        -- retain their existing keys; missing exit keys mean an untrained exit observer.
        Rt.ML.db:put("exitModelVersion", tostring(Const.ML_EXIT_MODEL_VERSION))
        Rt.ML.db:put("exitSamples", tostring(Rt.ML.exitSamples or 0))
        Rt.ML.db:put("exitWins", tostring(Rt.ML.exitWins or 0))
        Rt.ML.db:put("exitLosses", tostring(Rt.ML.exitLosses or 0))
        Rt.ML.db:put("exitSkipped", tostring(Rt.ML.exitSkipped or 0))
        for i = 1, #Const.ML_EXIT_FEATURE_NAMES do
            local name = Const.ML_EXIT_FEATURE_NAMES[i]
            Rt.ML.db:put("xw_" .. name, string.format("%.17g", Rt.ML.exitWeights[name] or 0.0))
        end
    end)
    if not ok then
        Rt.ML.storageReady = false
        Rt.ML.storageWarning = tostring(err)
        alert("ML STORAGE DISABLED: persist failed; continuing in memory | " .. tostring(err))
        return false
    end
    return true
end

local function isHistoricalExecutionProfile()
    local id = string.lower(tostring(profile:id() or ""))
    return string.find(id, "backtest", 1, true) ~= nil
        or string.find(id, "optimizer", 1, true) ~= nil
        or string.find(id, "simulation", 1, true) ~= nil
end

local function initializeMLStorage()
    if Rt.ML == nil or Cfg.MLMode == "OFF" or not Cfg.MLPersistModel
        or isHistoricalExecutionProfile() then return end
    Rt.ML.storageName = mlStorageName()
    local ok, err = pcall(function()
        local loaded = require("storagedb")
        local storageModule = type(loaded) == "table" and loaded or storagedb
        assert(type(storageModule) == "table" and type(storageModule.get_db) == "function",
            "storagedb.get_db is unavailable")
        Rt.ML.db = storageModule.get_db(Rt.ML.storageName)
        assert(Rt.ML.db ~= nil, "storagedb.get_db returned nil")
        Rt.ML.storageReady = true
        Rt.ML.storageBackend = "STORAGEDB"
        if Cfg.MLResetModel then
            mlPersistState()
            return
        end
        local storedVersion = tostring(Rt.ML.db:get("modelVersion", "0"))
        if storedVersion ~= "4" then
            alert("SMART AI MODEL VERSION CHANGED: incompatible stored model ignored and reset")
            mlPersistState()
            return
        end
        Rt.ML.wins = mlStoredCount(Rt.ML.db, "wins")
        Rt.ML.losses = mlStoredCount(Rt.ML.db, "losses")
        Rt.ML.samples = Rt.ML.wins + Rt.ML.losses
        Rt.ML.skipped = mlStoredCount(Rt.ML.db, "skipped")
        if tostring(Rt.ML.db:get("exitModelVersion", "0")) == tostring(Const.ML_EXIT_MODEL_VERSION) then
            Rt.ML.exitWins = mlStoredCount(Rt.ML.db, "exitWins")
            Rt.ML.exitLosses = mlStoredCount(Rt.ML.db, "exitLosses")
            Rt.ML.exitSamples = Rt.ML.exitWins + Rt.ML.exitLosses
            Rt.ML.exitSkipped = mlStoredCount(Rt.ML.db, "exitSkipped")
            for i = 1, #Const.ML_EXIT_FEATURE_NAMES do
                local name = Const.ML_EXIT_FEATURE_NAMES[i]
                Rt.ML.exitWeights[name] = clamp(tonumber(Rt.ML.db:get("xw_" .. name, "0")) or 0.0,
                    -Cfg.MLMaxAbsWeight, Cfg.MLMaxAbsWeight)
            end
        end
        local cal = tonumber(Rt.ML.db:get("calibratedWinRate", "0.5"))
        if validNumber(cal) then Rt.ML.calibratedWinRate = clamp(cal, 0.05, 0.95) end
        for i = 1, #ML_FEATURE_NAMES do
            local name = ML_FEATURE_NAMES[i]
            Rt.ML.weights[name] = clamp(tonumber(Rt.ML.db:get("w_" .. name, "0")) or 0.0,
                -Cfg.MLMaxAbsWeight, Cfg.MLMaxAbsWeight)
        end
    end)
    if not ok then
        local fileOK, fileError = pcall(function()
            local db, path = openFileStateDB(Rt.ML.storageName)
            Rt.ML.db = db
            Rt.ML.storageReady = true
            Rt.ML.storageBackend = "FILE"
            Rt.ML.storagePath = path
            if Cfg.MLResetModel then
                mlPersistState()
                return
            end
            local storedVersion = tostring(Rt.ML.db:get("modelVersion", "0"))
            if storedVersion ~= "4" then
                alert("SMART AI MODEL VERSION CHANGED: incompatible stored model ignored and reset")
                mlPersistState()
                return
            end
            Rt.ML.wins = mlStoredCount(Rt.ML.db, "wins")
            Rt.ML.losses = mlStoredCount(Rt.ML.db, "losses")
            Rt.ML.samples = Rt.ML.wins + Rt.ML.losses
            Rt.ML.skipped = mlStoredCount(Rt.ML.db, "skipped")
            if tostring(Rt.ML.db:get("exitModelVersion", "0")) == tostring(Const.ML_EXIT_MODEL_VERSION) then
                Rt.ML.exitWins = mlStoredCount(Rt.ML.db, "exitWins")
                Rt.ML.exitLosses = mlStoredCount(Rt.ML.db, "exitLosses")
                Rt.ML.exitSamples = Rt.ML.exitWins + Rt.ML.exitLosses
                Rt.ML.exitSkipped = mlStoredCount(Rt.ML.db, "exitSkipped")
                for i = 1, #Const.ML_EXIT_FEATURE_NAMES do
                    local name = Const.ML_EXIT_FEATURE_NAMES[i]
                    Rt.ML.exitWeights[name] = clamp(tonumber(Rt.ML.db:get("xw_" .. name, "0")) or 0.0,
                        -Cfg.MLMaxAbsWeight, Cfg.MLMaxAbsWeight)
                end
            end
            local cal = tonumber(Rt.ML.db:get("calibratedWinRate", "0.5"))
            if validNumber(cal) then Rt.ML.calibratedWinRate = clamp(cal, 0.05, 0.95) end
            for i = 1, #ML_FEATURE_NAMES do
                local name = ML_FEATURE_NAMES[i]
                Rt.ML.weights[name] = clamp(tonumber(Rt.ML.db:get("w_" .. name, "0")) or 0.0,
                    -Cfg.MLMaxAbsWeight, Cfg.MLMaxAbsWeight)
            end
        end)
        if not fileOK then
            Rt.ML.db = nil
            Rt.ML.storageReady = false
            Rt.ML.storageBackend = nil
            Rt.ML.storageWarning = "storagedb=" .. tostring(err) .. " | file=" .. tostring(fileError)
            alert("ML STORAGE UNAVAILABLE: continuing with in-memory model | " .. Rt.ML.storageWarning)
        end
    end
    if Rt.ML.storageReady then
        debug(string.format("SMART AI READY | mode=%s samples=%d wins=%d losses=%d cal=%.1f%% exitSamples=%d exitWins=%d exitLosses=%d persistent=%s backend=%s shared=%s group=%s namespace=%s featureSchema=%d features=%d exitFeatureSchema=%d exitFeatures=%d",
            Cfg.MLMode, Rt.ML.samples, Rt.ML.wins, Rt.ML.losses,
            (Rt.ML.calibratedWinRate or 0.5) * 100.0,
            Rt.ML.exitSamples or 0, Rt.ML.exitWins or 0, Rt.ML.exitLosses or 0,
            tostring(Rt.ML.storageReady), tostring(Rt.ML.storageBackend),
            tostring(Cfg.MLShareAcrossAccounts == true), tostring(Cfg.MLModelGroup or "OFF"),
            tostring(mlStorageName()), Const.ML_FEATURE_SCHEMA, #ML_FEATURE_NAMES,
            Const.ML_EXIT_FEATURE_SCHEMA, #Const.ML_EXIT_FEATURE_NAMES))
    end
end

-- Restart-safe deterministic runtime metadata. This is deliberately separate
-- from the optional ML model: trade management, cooldown and setup reuse must
-- survive a terminal restart even when ML persistence is disabled.
local function runtimeStorageName()
    -- v7 Probability Edge Engine must not inherit cooldown/setup-reuse state
    -- from the legacy v6.x deterministic entry engine.  The old ARSRT_V2
    -- key used only CustomID/account/instrument/timeframe, so launching v7
    -- with the same CustomID could restore a v6 lastEntryDate/usedSetupKeys
    -- and falsely report cooldown/setup already traded before v7 had ever
    -- opened a trade.  Keep one stable namespace for the v7 engine so
    -- restart recovery still works across v7 maintenance builds.
    local engineNamespace = "PROB_EDGE_V7"
    local identity = table.concat({engineNamespace, tostring(Cfg.CustomID or "NA"),
        tostring(Rt.Account or "NA"), tostring(instance.bid:instrument() or "NA"),
        tostring(Cfg.TF or "NA")}, "|")
    local label = string.sub(string.gsub(tostring(Cfg.CustomID or "NA"), "[^%w_]", "_"), 1, 24)
    return "ARSRT_V3_" .. label .. "_" .. stableTextHash(identity)
end

-- FXTS2 installations do not consistently include the optional storagedb
-- module. This append-only fallback provides the same get/put contract using
-- Lua file I/O. Hex encoding and a checksum make an interrupted final record
-- safe to ignore on the next launch.
local FileState = {}

function FileState.hexEncode(value)
    return (string.gsub(tostring(value or ""), ".", function(ch)
        return string.format("%02X", string.byte(ch))
    end))
end

function FileState.hexDecode(value)
    if type(value) ~= "string" or string.len(value) % 2 ~= 0
        or string.find(value, "[^0-9A-F]", 1) ~= nil then return nil end
    local decoded = {}
    for i = 1, string.len(value), 2 do
        local byteValue = tonumber(string.sub(value, i, i + 1), 16)
        if byteValue == nil then return nil end
        decoded[#decoded + 1] = string.char(byteValue)
    end
    return table.concat(decoded)
end

function FileState.appendUniquePath(paths, seen, path)
    if type(path) ~= "string" or path == "" or seen[path] then return end
    seen[path] = true
    paths[#paths + 1] = path
end

function FileState.runtimeCandidates(storageName)
    local paths, seen = {}, {}
    local filename = csvSafeFilePart(storageName) .. ".state"
    local configured = trimText(Cfg.CSVLogFile)
    if configured ~= "" then
        local lower = string.lower(configured)
        local directory = nil
        if string.sub(lower, -4) == ".csv" then
            for i = string.len(configured), 1, -1 do
                local ch = string.sub(configured, i, i)
                if ch == "\\" or ch == "/" then
                    directory = string.sub(configured, 1, i)
                    break
                end
            end
        else
            directory = configured
            local last = string.sub(directory, -1)
            if last ~= "\\" and last ~= "/" then
                local separator = string.find(directory, "\\", 1, true) ~= nil and "\\" or "/"
                directory = directory .. separator
            end
        end
        if directory ~= nil then FileState.appendUniquePath(paths, seen, directory .. filename) end
    end

    if type(os) == "table" and type(os.getenv) == "function" then
        local localAppData = os.getenv("LOCALAPPDATA")
        local appData = os.getenv("APPDATA")
        if localAppData ~= nil and localAppData ~= "" then
            FileState.appendUniquePath(paths, seen, localAppData .. "\\" .. filename)
        end
        if appData ~= nil and appData ~= "" then
            FileState.appendUniquePath(paths, seen, appData .. "\\" .. filename)
        end
    end
    FileState.appendUniquePath(paths, seen, filename)
    return paths
end

function FileState.openAtPath(path)
    assert(type(io) == "table" and type(io.open) == "function",
        "Lua file I/O is unavailable in this host")
    local values = {}
    local lineCount = 0
    local existing = io.open(path, "r")
    if existing ~= nil then
        for line in existing:lines() do
            lineCount = lineCount + 1
            local keyHex, valueHex, checksum = string.match(line,
                "^([0-9A-F]+)\t([0-9A-F]*)\t(%d+)$")
            if keyHex ~= nil then
                local key = FileState.hexDecode(keyHex)
                local value = FileState.hexDecode(valueHex)
                if key ~= nil and value ~= nil
                    and checksum == stableTextHash(key .. "\0" .. value) then
                    values[key] = value
                end
            end
        end
        local closeOK, closeError = pcall(function() existing:close() end)
        if not closeOK then error(closeError or "unable to close runtime state file") end
    end

    -- Compaction: append-only puts leave historical duplicates. When the file
    -- has more lines than live keys (or a large absolute size), rewrite a
    -- single snapshot so startup cost stays bounded on long-running hosts
    -- without native storagedb.
    local keyCount = 0
    for _ in pairs(values) do keyCount = keyCount + 1 end
    if lineCount > keyCount and (lineCount >= 64 or lineCount > keyCount * 2) then
        local keys = {}
        for key, _ in pairs(values) do keys[#keys + 1] = key end
        table.sort(keys)
        local compact = {}
        for i = 1, #keys do
            local key = keys[i]
            local textValue = tostring(values[key] or "")
            compact[#compact + 1] = FileState.hexEncode(key) .. "\t" .. FileState.hexEncode(textValue)
                .. "\t" .. stableTextHash(key .. "\0" .. textValue) .. "\n"
        end
        local out, outError = io.open(path, "w")
        if out == nil then error(outError or "unable to compact runtime state file") end
        local writeOK, writeError = out:write(table.concat(compact))
        local flushOK, flushError = pcall(function() out:flush() end)
        local closeOK, closeError = pcall(function() out:close() end)
        if not writeOK then error(writeError or "unable to write compacted runtime state") end
        if not flushOK then error(flushError or "unable to flush compacted runtime state") end
        if not closeOK then error(closeError or "unable to close compacted runtime state") end
    end

    local probe, probeError = io.open(path, "a")
    if probe == nil then error(probeError or "unable to open runtime state file") end
    local probeCloseOK, probeCloseError = pcall(function() probe:close() end)
    if not probeCloseOK then error(probeCloseError or "unable to close runtime state file") end

    local db = {path=path}
    function db:get(key, fallback)
        local value = values[tostring(key)]
        if value == nil then return fallback end
        return value
    end
    function db:put(key, value)
        local textKey = tostring(key)
        local textValue = tostring(value or "")
        if values[textKey] == textValue then return true end
        local record = FileState.hexEncode(textKey) .. "\t" .. FileState.hexEncode(textValue)
            .. "\t" .. stableTextHash(textKey .. "\0" .. textValue) .. "\n"
        local file, openError = io.open(path, "a")
        if file == nil then error(openError or "unable to open runtime state file") end
        local writeOK, writeError = file:write(record)
        if not writeOK then
            pcall(function() file:close() end)
            error(writeError or "unable to write runtime state file")
        end
        local flushOK, flushError = pcall(function() file:flush() end)
        local closeOK, closeError = pcall(function() file:close() end)
        if not flushOK then error(flushError or "unable to flush runtime state file") end
        if not closeOK then error(closeError or "unable to close runtime state file") end
        values[textKey] = textValue
        return true
    end
    return db
end

openFileStateDB = function(storageName)
    local errors = {}
    local candidates = FileState.runtimeCandidates(storageName)
    for i = 1, #candidates do
        local ok, dbOrError = pcall(function()
            return FileState.openAtPath(candidates[i])
        end)
        if ok and dbOrError ~= nil then return dbOrError, candidates[i] end
        errors[#errors + 1] = candidates[i] .. ": " .. tostring(dbOrError)
    end
    error("no writable runtime-state path | " .. table.concat(errors, " | "))
end

local function initializeRuntimeStorage()
    if not Cfg.AllowTrade or isHistoricalExecutionProfile() then return end
    local storageName = runtimeStorageName()
    local nativeOK, nativeError = pcall(function()
        local loaded = require("storagedb")
        local storageModule = type(loaded) == "table" and loaded or storagedb
        assert(type(storageModule) == "table" and type(storageModule.get_db) == "function",
            "storagedb.get_db is unavailable")
        Rt.RuntimeDB = storageModule.get_db(storageName)
        assert(Rt.RuntimeDB ~= nil, "storagedb.get_db returned nil")
        Rt.runtimeStorageReady = true
        Rt.runtimeStorageBackend = "STORAGEDB"
        Rt.runtimeStoragePath = nil
    end)
    if nativeOK then return end

    local fileOK, fileError = pcall(function()
        local db, path = openFileStateDB(storageName)
        Rt.RuntimeDB = db
        Rt.runtimeStorageReady = true
        Rt.runtimeStorageBackend = "FILE"
        Rt.runtimeStoragePath = path
    end)
    if fileOK then
        debug("RUNTIME STATE STORAGE READY | backend=FILE | " .. tostring(Rt.runtimeStoragePath))
    else
        Rt.RuntimeDB = nil
        Rt.runtimeStorageReady = false
        Rt.runtimeStorageBackend = nil
        Rt.runtimeStoragePath = nil
        Rt.runtimeStorageWarning = "storagedb=" .. tostring(nativeError)
            .. " | file=" .. tostring(fileError)
        alert("RUNTIME STATE STORAGE UNAVAILABLE: restart recovery is degraded | "
            .. Rt.runtimeStorageWarning)
    end
end

local function runtimeGet(key, fallback)
    if not Rt.runtimeStorageReady or Rt.RuntimeDB == nil then return fallback end
    local ok, value = pcall(function() return Rt.RuntimeDB:get(key, fallback) end)
    if not ok then return fallback end
    return value
end

local function runtimePut(key, value)
    if not Rt.runtimeStorageReady or Rt.RuntimeDB == nil then return false end
    local ok, err = pcall(function() Rt.RuntimeDB:put(key, tostring(value or "")) end)
    if not ok then
        Rt.runtimeStorageReady = false
        Rt.runtimeStorageWarning = tostring(err)
        alert("RUNTIME STATE STORAGE DISABLED: persist failed; restart recovery is degraded | "
            .. tostring(err))
        return false
    end
    return true
end

local function tradeStateKey(tradeId, field)
    return "trade_" .. tostring(tradeId) .. "_" .. field
end

local function serializeMLFeatures(features)
    if features == nil then return "" end
    local values = {}
    for i = 1, #ML_FEATURE_NAMES do
        local value = tonumber(features[ML_FEATURE_NAMES[i]])
        if not validNumber(value) then return "" end
        values[#values + 1] = string.format("%.17g", value)
    end
    return table.concat(values, ",")
end

local function serializeExitMLFeatures(features)
    if features == nil then return "" end
    local values = {}
    for i = 1, #Const.ML_EXIT_FEATURE_NAMES do
        local value = tonumber(features[Const.ML_EXIT_FEATURE_NAMES[i]])
        if not validNumber(value) then return "" end
        values[#values + 1] = string.format("%.17g", value)
    end
    return table.concat(values, ",")
end

local function deserializeExitMLFeatures(text, schemaVersion)
    if type(text) ~= "string" or text == ""
        or tostring(schemaVersion or "") ~= tostring(Const.ML_EXIT_FEATURE_SCHEMA) then return nil end
    local values = {}
    for valueText in string.gmatch(text .. ",", "(.-),") do values[#values + 1] = valueText end
    if #values ~= #Const.ML_EXIT_FEATURE_NAMES then return nil end
    local features = {}
    for i = 1, #Const.ML_EXIT_FEATURE_NAMES do
        local value = tonumber(values[i])
        if not validNumber(value) then return nil end
        features[Const.ML_EXIT_FEATURE_NAMES[i]] = value
    end
    return features
end

local function deserializeMLFeatures(text, schemaVersion)
    if type(text) ~= "string" or text == "" then return nil end
    local values = {}
    for valueText in string.gmatch(text .. ",", "(.-),") do
        values[#values + 1] = valueText
    end
    local oldSchema = tostring(schemaVersion or Const.ML_FEATURE_SCHEMA) == "4"
    local names = oldSchema and Const.ML_FEATURE_NAMES_V4 or ML_FEATURE_NAMES
    if #values ~= #names then return nil end
    local features = {}
    for i = 1, #names do
        local value = tonumber(values[i])
        if not validNumber(value) then return nil end
        features[names[i]] = value
    end
    if oldSchema then
        for i = 1, #ML_FEATURE_NAMES do
            local name = ML_FEATURE_NAMES[i]
            if features[name] == nil then features[name] = 0.0 end
        end
    end
    return features
end

local function cooldownReferencePeriod()
    -- v9.1.2: cooldown begins ONLY after broker-confirmed trade closure.
    -- Entry time is deliberately excluded. While a trade is open, position
    -- limits/AllowMultiple control additional entries; once the broker publishes
    -- the matching closed-trade row, refreshClosedTradeLosses() records
    -- Rt.lastTradeClosePeriod and the operator-configured cooldown starts.
    local closePeriod = Rt.lastTradeClosePeriod
    return closePeriod, closePeriod ~= nil and "confirmed close" or nil
end

function Rt.persistExitTradeFeatures(tradeId)
    if tradeId == nil then return end
    local features = Rt.tradeExitFeatures[tradeId] or Rt.tradeExitFeatures[tostring(tradeId)]
    local serialized = serializeExitMLFeatures(features)
    runtimePut(tradeStateKey(tradeId, "exitFeatureSchema"), serialized ~= ""
        and tostring(Const.ML_EXIT_FEATURE_SCHEMA) or "")
    runtimePut(tradeStateKey(tradeId, "exitNamespace"), serialized ~= "" and mlStorageName() or "")
    runtimePut(tradeStateKey(tradeId, "exitFeatures"), serialized)
end

local function persistTradeMetadata(tradeId)
    if tradeId == nil then return end
    runtimePut(tradeStateKey(tradeId, "regime"), Rt.tradeEntryRegime[tradeId] or "")
    runtimePut(tradeStateKey(tradeId, "engine"), Rt.tradeEntryEngine[tradeId] or "")
    local anchor = Rt.tradeSetupAnchor[tradeId]
    runtimePut(tradeStateKey(tradeId, "anchor"), validNumber(anchor) and string.format("%.17g", anchor) or "")
    local initialRisk = Rt.tradeInitialRisk[tradeId]
    runtimePut(tradeStateKey(tradeId, "initialRisk"),
        validNumber(initialRisk) and initialRisk > 0 and string.format("%.17g", initialRisk) or "")
    local trailStop = Rt.trailStops[tradeId]
    runtimePut(tradeStateKey(tradeId, "trailStop"),
        validNumber(trailStop) and string.format("%.17g", trailStop) or "")
    local features = Rt.tradeMLFeatures[tradeId] or Rt.tradeMLFeatures[tostring(tradeId)]
    local serializedFeatures = serializeMLFeatures(features)
    runtimePut(tradeStateKey(tradeId, "mlFeatureSchema"), serializedFeatures ~= ""
        and tostring(Const.ML_FEATURE_SCHEMA) or "")
    runtimePut(tradeStateKey(tradeId, "mlNamespace"),
        serializedFeatures ~= "" and mlStorageName() or "")
    runtimePut(tradeStateKey(tradeId, "mlFeatures"), serializedFeatures)
    Rt.persistExitTradeFeatures(tradeId)
    runtimePut(tradeStateKey(tradeId, "lineageRoot"), Rt.tradeLineageRoot[tradeId] or "")
end

local function loadTradeMetadata(tradeId)
    if tradeId == nil then return false end
    local regime = tostring(runtimeGet(tradeStateKey(tradeId, "regime"), "") or "")
    local engine = tostring(runtimeGet(tradeStateKey(tradeId, "engine"), "") or "")
    local anchor = tonumber(runtimeGet(tradeStateKey(tradeId, "anchor"), ""))
    local initialRisk = tonumber(runtimeGet(tradeStateKey(tradeId, "initialRisk"), ""))
    local trailStop = tonumber(runtimeGet(tradeStateKey(tradeId, "trailStop"), ""))
    local mlFeatureSchema = tostring(runtimeGet(tradeStateKey(tradeId, "mlFeatureSchema"), "") or "")
    local mlNamespace = tostring(runtimeGet(tradeStateKey(tradeId, "mlNamespace"), "") or "")
    local features = nil
    if (mlFeatureSchema == "4" or mlFeatureSchema == tostring(Const.ML_FEATURE_SCHEMA))
        and mlNamespace == mlStorageName() then
        features = deserializeMLFeatures(tostring(
            runtimeGet(tradeStateKey(tradeId, "mlFeatures"), "") or ""), mlFeatureSchema)
    end
    local exitFeatureSchema = tostring(runtimeGet(tradeStateKey(tradeId, "exitFeatureSchema"), "") or "")
    local exitNamespace = tostring(runtimeGet(tradeStateKey(tradeId, "exitNamespace"), "") or "")
    local exitFeatures = nil
    if exitFeatureSchema == tostring(Const.ML_EXIT_FEATURE_SCHEMA)
        and exitNamespace == mlStorageName() then
        exitFeatures = deserializeExitMLFeatures(tostring(
            runtimeGet(tradeStateKey(tradeId, "exitFeatures"), "") or ""), exitFeatureSchema)
    end
    if regime ~= "" then Rt.tradeEntryRegime[tradeId] = regime end
    if engine ~= "" then Rt.tradeEntryEngine[tradeId] = engine end
    if validNumber(anchor) then Rt.tradeSetupAnchor[tradeId] = anchor end
    if validNumber(initialRisk) and initialRisk > 0 then Rt.tradeInitialRisk[tradeId] = initialRisk end
    if validNumber(trailStop) then Rt.trailStops[tradeId] = trailStop end
    if features ~= nil then
        Rt.tradeMLFeatures[tradeId] = features
        Rt.tradeMLFeatures[tostring(tradeId)] = features
    end
    if exitFeatures ~= nil then
        Rt.tradeExitFeatures[tradeId] = exitFeatures
        Rt.tradeExitFeatures[tostring(tradeId)] = exitFeatures
    end
    local lineageRoot = tostring(runtimeGet(tradeStateKey(tradeId, "lineageRoot"), "") or "")
    if lineageRoot ~= "" and lineageRoot ~= "0" then Rt.tradeLineageRoot[tradeId] = lineageRoot end
    return regime ~= "" or engine ~= "" or validNumber(anchor)
        or (validNumber(initialRisk) and initialRisk > 0) or validNumber(trailStop)
        or features ~= nil or exitFeatures ~= nil
end

local function persistEntryRuntimeState()
    if not Rt.runtimeStorageReady or Rt.Source == nil then return end
    if Rt.lastEntryPeriod ~= nil and Rt.Source:date(Rt.lastEntryPeriod) ~= nil then
        runtimePut("lastEntryDate", string.format("%.17g", Rt.Source:date(Rt.lastEntryPeriod)))
    else
        runtimePut("lastEntryDate", "")
    end
    if Rt.lastTradeClosePeriod ~= nil and Rt.Source:date(Rt.lastTradeClosePeriod) ~= nil then
        runtimePut("lastTradeCloseDate", string.format("%.17g", Rt.Source:date(Rt.lastTradeClosePeriod)))
    else
        runtimePut("lastTradeCloseDate", "")
    end
    local entries = {}
    for key, usedPeriod in pairs(Rt.usedSetupKeys) do
        local dateValue = usedPeriod ~= nil and Rt.Source:date(usedPeriod) or nil
        if validNumber(dateValue) then
            entries[#entries + 1] = tostring(key) .. "@" .. string.format("%.17g", dateValue)
        end
    end
    table.sort(entries)
    runtimePut("usedSetupKeys", table.concat(entries, ";"))
end

local function restoreRecentPeriod(savedDate, currentDate, p, maxAgeBars)
    -- Prefer an exact bar match. If the saved date is not in loaded history,
    -- do NOT estimate age from wall-clock minutes: weekends/holidays make that
    -- count diverge from actual closed bars and can mis-revive cooldown or
    -- setup-reuse state. Returning nil clears the restored field (fail open on
    -- cooldown/setup after a gap rather than guess).
    if not validNumber(savedDate) or not validNumber(currentDate)
        or savedDate > currentDate + 1.0 / 86400.0 then return nil end
    local idx = core.findDate(Rt.Source, savedDate, false)
    if idx ~= -1 then
        if p - idx < maxAgeBars then return idx end
        return nil
    end
    return nil
end

local function restoreEntryRuntimeState(p)
    if Rt.entryStateRestored then return end
    Rt.entryStateRestored = true
    if not Rt.runtimeStorageReady or Rt.Source == nil then return end
    local currentDate = Rt.Source:date(p)
    local lastDate = tonumber(runtimeGet("lastEntryDate", ""))
    Rt.lastEntryPeriod = restoreRecentPeriod(lastDate, currentDate, p,
        max(1, Cfg.MinBarsBetweenTrades + 1))
    local lastCloseDate = tonumber(runtimeGet("lastTradeCloseDate", ""))
    Rt.lastTradeClosePeriod = restoreRecentPeriod(lastCloseDate, currentDate, p,
        max(1, Cfg.MinBarsBetweenTrades + 1))
    local serialized = tostring(runtimeGet("usedSetupKeys", "") or "")
    for item in string.gmatch(serialized .. ";", "(.-);") do
        local key, dateText = string.match(item, "^(.-)@([%d%.%-eE]+)$")
        local dateValue = tonumber(dateText)
        if key ~= nil and key ~= "" and validNumber(dateValue) and validNumber(currentDate)
            and dateValue <= currentDate + 1.0 / 86400.0 then
            local expiry = string.find(key, ":PB:", 1, true)
                and max(Cfg.SetupResetBars, max((Cfg.PullbackMaxAgeBars or 5)+1,
                    (Cfg.CleanPullbackRetestLookbackBars or 0)+1)) or Cfg.SetupResetBars
            local usedPeriod = restoreRecentPeriod(dateValue, currentDate, p, expiry)
            if usedPeriod ~= nil then Rt.usedSetupKeys[key] = usedPeriod end
        end
    end
end

-- Smart AI ensemble packed into one table so each method is NOT a main-chunk
-- local (Lua 5.1 limit: 200 locals). Call sites use SmartAI.* names.
local SmartAI = {}

function SmartAI.buildFeatures(side, regime, score, required, setup)
    local c = Context
    local st = Rt.marketStructure or {}
    local sign = side == "B" and 1.0 or -1.0
    local atr = tonumber(c.atr) or 0.0
    local close = tonumber(c.close) or 0.0
    local open = tonumber(c.open) or close
    local high = tonumber(c.high) or close
    local low = tonumber(c.low) or close
    local fastEMA = tonumber(c.emaFast) or close
    local mediumEMA = tonumber(c.emaMed) or close
    local slowEMA = tonumber(c.emaSlow) or close
    local function signedATR(value)
        if atr <= 0 or not validNumber(value) then return 0.0 end
        -- A value of +/-1 represents a +/-2 ATR gap, bounding rare outliers.
        return clamp(sign * value / (2.0 * atr), -1.0, 1.0)
    end
    local closeLocation = 0.0
    if high > low then
        local location = clamp((close - low) / (high - low), 0.0, 1.0)
        closeLocation = 2.0 * (side == "B" and location or 1.0 - location) - 1.0
    end
    local setupText = string.upper(tostring(setup or "UNKNOWN"))
    local isPullback = string.find(setupText, "PULLBACK", 1, true) ~= nil
    local isBreakout = string.find(setupText, "BREAKOUT", 1, true) ~= nil
    local isContinuation = string.find(setupText, "CONTINUATION", 1, true) ~= nil
    local isRange = string.find(setupText, "RANGE", 1, true) ~= nil
    local isFade = string.find(setupText, "FADE", 1, true) ~= nil
    local isReversal = string.find(setupText, "REVERSAL", 1, true) ~= nil
    local plusDI = tonumber(c.plusDirection) or 0.0
    local minusDI = tonumber(c.minusDirection) or 0.0
    local rsi = tonumber(c.rsi) or 50.0
    local vwapDistance = tonumber(c.vwapDistATR) or 0.0
    local rangePosition = clamp(tonumber(c.rangePosition) or 0.5, 0, 1)
    local session = tostring(Rt.activeMarketSession or "OFF_HOURS")
    local htfAlignment = 0.0
    if Rt.htfStatus == "READY" and Rt.htfLastDate ~= nil then
        if Rt.htfTrend == (side == "B" and 1 or -1) then htfAlignment = 1.0
        elseif Rt.htfTrend == (side == "B" and -1 or 1) then htfAlignment = -1.0 end
    end
    local spreadRatio = safeDiv(spreadPips(Rt.processingPeriod), max(Cfg.MaxSpreadPips, 0.000001), 2.0)

    local structureBias = 0.0
    local wantedBias = side == "B" and "BULLISH" or "BEARISH"
    if st.bias == wantedBias then structureBias = 1.0
    elseif st.bias == (side == "B" and "BEARISH" or "BULLISH") then structureBias = -1.0 end
    local chochOppose = 0.0
    if st.choch then
        if (side == "B" and st.chochDirection == "DOWN")
            or (side == "S" and st.chochDirection == "UP") then
            chochOppose = 1.0
        end
    end
    local bosAlign = 0.0
    if side == "B" and st.bosUp then bosAlign = 1.0
    elseif side == "S" and st.bosDown then bosAlign = 1.0 end

    local stBias = tostring(Rt.smartStateBias or "NEUTRAL")
    local sideBias = side == "B" and "BULL" or "BEAR"
    local stateAlign = 0.0
    if stBias == sideBias then stateAlign = 1.0
    elseif stBias ~= "NEUTRAL" and stBias ~= sideBias then stateAlign = -1.0 end
    local stateConf = clamp((tonumber(Rt.smartStateConfidence) or 0) / 100.0, 0, 1)

    local edge = clamp((score - required) / 20.0, -1, 1)
    local lossStreak = clamp((Rt.consecutiveLosses or 0) / max(Cfg.MaxConsecutiveLosses or 3, 1), 0, 1)
    local volQuiet = clamp((Scores.lowVol or 0) / 10.0, 0, 1)
    local volHigh = clamp((Scores.highVol or 0) / 10.0, 0, 1)

    return {
        bias = 1.0,
        ruleQuality = edge,
        regimeMargin = clamp(((Rt.regimeBestScore or 0) - (Rt.regimeSecondScore or 0)) / 4.0, 0, 1),
        adxStrength = clamp(((tonumber(c.adx) or 18.0) - 18.0) / 22.0, -1, 1),
        dmiAlignment = clamp(sign * (plusDI - minusDI) / 40.0, -1, 1),
        rsiAlignment = clamp(sign * (rsi - 50.0) / 30.0, -1, 1),
        momentumAlignment = clamp(sign * (tonumber(c.momentumATR) or 0.0) / 3.0, -1, 1),
        vwapAlignment = clamp(sign * vwapDistance / 3.0, -1, 1),
        vwapStretch = clamp(abs(vwapDistance) / 5.0, 0, 1),
        efficiency = clamp(tonumber(c.efficiency) or 0.0, 0, 1),
        atrPercentile = 2.0 * clamp(tonumber(c.atrPct) or 0.5, 0, 1) - 1.0,
        bbPercentile = 2.0 * clamp(tonumber(c.bbPct) or 0.5, 0, 1) - 1.0,
        rangeEdge = 2.0 * (side == "B" and (1.0 - rangePosition) or rangePosition) - 1.0,
        compression = c.consolidationOK and 1.0 or 0.0,
        htfAlignment = htfAlignment,
        spreadCost = clamp(spreadRatio / 2.0, 0, 1),
        sideShort = side == "S" and 1.0 or 0.0,
        sessionSydney = session == "SYDNEY" and 1.0 or 0.0,
        sessionSydneyTokyo = session == "SYDNEY_TOKYO_OVERLAP" and 1.0 or 0.0,
        sessionTokyo = session == "TOKYO" and 1.0 or 0.0,
        sessionTokyoLondon = session == "TOKYO_LONDON_OVERLAP" and 1.0 or 0.0,
        sessionLondon = session == "LONDON" and 1.0 or 0.0,
        sessionLondonNewYork = session == "LONDON_NEW_YORK_OVERLAP" and 1.0 or 0.0,
        sessionNewYork = session == "NEW_YORK" and 1.0 or 0.0,
        sessionOffHours = session == "OFF_HOURS" and 1.0 or 0.0,
        regimeTrend = string.sub(regime, 1, 8) == "TRENDING" and 1.0 or 0.0,
        regimeRange = regime == "CHOPPY_RANGE" and 1.0 or 0.0,
        regimeBreakout = string.sub(regime, 1, 8) == "BREAKOUT" and 1.0 or 0.0,
        regimeReversal = string.sub(regime, 1, 8) == "REVERSAL" and 1.0 or 0.0,
        structureBias = structureBias,
        structureQuality = clamp((tonumber(st.quality) or 0) / 100.0, 0, 1),
        structureConfidence = clamp((tonumber(st.confidence) or 0) / 100.0, 0, 1),
        chochOppose = chochOppose,
        bosAlign = bosAlign,
        stateAlign = stateAlign,
        stateConfidence = stateConf,
        evidenceEdge = edge,
        lossStreak = lossStreak,
        volQuiet = volQuiet,
        volHigh = volHigh,
        priceFastEMA = signedATR(close - fastEMA),
        priceMediumEMA = signedATR(close - mediumEMA),
        priceSlowEMA = signedATR(close - slowEMA),
        fastMediumEMAGap = signedATR(fastEMA - mediumEMA),
        mediumSlowEMAGap = signedATR(mediumEMA - slowEMA),
        fastEMASlope = signedATR(tonumber(c.emaFastSlope) or 0.0),
        mediumEMASlope = signedATR(tonumber(c.emaMedSlope) or 0.0),
        fastEMATouchDepth = signedATR(side == "B" and (low - fastEMA) or (fastEMA - high)),
        mediumEMATouchDepth = signedATR(side == "B" and (low - mediumEMA) or (mediumEMA - high)),
        triggerBody = signedATR(close - open),
        triggerCloseLocation = closeLocation,
        setupPullback = isPullback and 1.0 or 0.0,
        setupBreakout = isBreakout and 1.0 or 0.0,
        setupContinuation = isContinuation and 1.0 or 0.0,
        setupRange = isRange and 1.0 or 0.0,
        setupFade = isFade and 1.0 or 0.0,
        setupReversal = isReversal and 1.0 or 0.0,
    }
end

function SmartAI.logisticProbability(features)
    if Rt.ML == nil or features == nil then return 0.5 end
    local z = 0.0
    for i = 1, #ML_FEATURE_NAMES do
        local name = ML_FEATURE_NAMES[i]
        z = z + (Rt.ML.weights[name] or 0.0) * (features[name] or 0.0)
    end
    z = clamp(z, -30.0, 30.0)
    return 1.0 / (1.0 + math.exp(-z))
end

function SmartAI.empiricalPrior()
    if Rt.ML == nil then return 0.5 end
    local wins = (Rt.ML.wins or 0) + 1.0
    local losses = (Rt.ML.losses or 0) + 1.0
    return wins / (wins + losses)
end

function SmartAI.recentPrior()
    if Rt.ML == nil then return 0.5 end
    local window = Rt.ML.recentWindow
    if type(window) ~= "table" or #window == 0 then
        return Rt.ML.calibratedWinRate or 0.5
    end
    local sum = 0.0
    for i = 1, #window do sum = sum + window[i] end
    return sum / #window
end

function SmartAI.statePrior(features)
    local base = 0.5
    if features == nil then return base end
    local align = tonumber(features.stateAlign) or 0
    local conf = tonumber(features.stateConfidence) or 0
    if align > 0 and conf >= 0.55 then
        return clamp(0.5 + 0.12 * conf, 0.5, 0.68)
    end
    if align < 0 and conf >= 0.60 then
        return clamp(0.5 - 0.12 * conf, 0.32, 0.5)
    end
    return base
end

function SmartAI.predict(features)
    if Rt.ML == nil or features == nil then return 0.5 end
    local logistic = SmartAI.logisticProbability(features)
    local empiric = SmartAI.empiricalPrior()
    local recent = SmartAI.recentPrior()
    local stateP = SmartAI.statePrior(features)
    local samples = Rt.ML.samples or 0
    local minN = max(Cfg.MLMinSamples or 50, 1)
    local trainFrac = clamp(samples / (minN * 1.5), 0, 1)
    local wLog = 0.15 + 0.55 * trainFrac
    local wEmp = 0.25 - 0.10 * trainFrac
    local wRec = 0.25 - 0.05 * trainFrac
    local wSt = 0.35 - 0.20 * trainFrac
    local total = wLog + wEmp + wRec + wSt
    local p = (wLog * logistic + wEmp * empiric + wRec * recent + wSt * stateP) / total
    if (tonumber(features.chochOppose) or 0) >= 0.5 then
        p = min(p, 0.48)
    end
    if (tonumber(features.lossStreak) or 0) >= 0.67 then
        p = p * 0.92
    end
    p = clamp(p, 0.02, 0.98)
    Rt.ML.lastProbability = p
    return p
end

function SmartAI.adaptiveThreshold(features)
    local base = Cfg.MLProbabilityThreshold or 0.58
    if not Cfg.MLAdaptiveThreshold then return base end
    local add = 0.0
    if features ~= nil then
        if (tonumber(features.lossStreak) or 0) >= 0.5 then add = add + 0.03 end
        if (tonumber(features.volHigh) or 0) >= 0.7 then add = add + 0.02 end
        if (tonumber(features.stateAlign) or 0) < 0
            and (tonumber(features.stateConfidence) or 0) >= 0.6 then
            add = add + 0.03
        end
        if (tonumber(features.chochOppose) or 0) >= 0.5 then add = add + 0.04 end
        if (tonumber(features.stateAlign) or 0) > 0
            and (tonumber(features.stateConfidence) or 0) >= 0.75
            and (tonumber(features.structureBias) or 0) > 0 then
            add = add - 0.02
        end
    end
    return clamp(base + add, 0.50, 0.90)
end

function SmartAI.contributorText(features)
    if Rt.ML == nil or features == nil or (Rt.ML.samples or 0) == 0 then return "untrained" end
    local ranked = {}
    for i = 1, #ML_FEATURE_NAMES do
        local name = ML_FEATURE_NAMES[i]
        local contribution = (Rt.ML.weights[name] or 0.0) * (features[name] or 0.0)
        if abs(contribution) > 0.000001 then
            ranked[#ranked + 1] = {name=name, value=contribution}
        end
    end
    table.sort(ranked, function(a, b) return abs(a.value) > abs(b.value) end)
    local parts = {}
    for i = 1, min(4, #ranked) do
        parts[#parts + 1] = ranked[i].name .. string.format("=%+.2f", ranked[i].value)
    end
    return #parts > 0 and table.concat(parts, ",") or "neutral"
end

function SmartAI.evaluateEntry(side, regime, score, required, setup)
    if Cfg.MLMode == "OFF" or Rt.ML == nil then
        return {status="OFF", probability=nil, features=nil, block=false, samples=0,
            threshold=nil, ensemble="off"}
    end
    local features = SmartAI.buildFeatures(side, regime, score, required, setup)
    local logistic = SmartAI.logisticProbability(features)
    local probability = SmartAI.predict(features)
    local threshold = SmartAI.adaptiveThreshold(features)
    local samples = Rt.ML.samples or 0
    local trained = samples >= Cfg.MLMinSamples
    local block = Cfg.MLMode == "FILTER" and trained and probability < threshold
    local status
    if Cfg.MLMode == "OBSERVE" then status = trained and "OBSERVE" or "OBSERVE_WARMUP"
    elseif not trained then status = "FILTER_WARMUP_PASS"
    elseif block then status = "BLOCK"
    else status = "PASS" end
    return {
        status=status, probability=probability, features=features,
        block=block, samples=samples, trained=trained,
        threshold=threshold, logistic=logistic,
        empiric=SmartAI.empiricalPrior(), recent=SmartAI.recentPrior(),
        contributors=SmartAI.contributorText(features),
        ensemble="smartAI_v5_entry"
    }
end

-- This separate observer learns associations between an open-trade state and
-- its eventual result. It is diagnostic-only: it never changes exit rules.
function SmartAI.buildExitFeatures(tradeRow, snapshot, currentR, breakEven, brokerStop)
    if Cfg.MLMode == "OFF" or tradeRow == nil or snapshot == nil or Rt.contextReadyForBar ~= true
        or not validNumber(Context.atr) or Context.atr <= 0 then return nil end
    local side = tradeRow.BS == "B" and "B" or "S"
    local sign = side == "B" and 1.0 or -1.0
    local atr = Context.atr
    local close = tonumber(Context.close)
    if not validNumber(close) or not validNumber(Context.emaFast)
        or not validNumber(Context.emaMed) or not validNumber(Context.emaSlow) then return nil end
    local function signedATR(value, scale)
        if not validNumber(value) then return 0.0 end
        return clamp(sign * value / (atr * (scale or 2.0)), -1.0, 1.0)
    end
    local risk = tonumber(snapshot.initialRisk)
    local mfeR = validNumber(risk) and risk > 0 and (tonumber(snapshot.mfePrice) or 0) / risk or 0
    local maeR = validNumber(risk) and risk > 0 and (tonumber(snapshot.maePrice) or 0) / risk or 0
    local givebackR = validNumber(currentR) and (mfeR - currentR) or 0
    local stack = 0.0
    if Context.emaFast > Context.emaMed and Context.emaMed > Context.emaSlow then
        stack = side == "B" and 1.0 or -1.0
    elseif Context.emaFast < Context.emaMed and Context.emaMed < Context.emaSlow then
        stack = side == "S" and 1.0 or -1.0
    end
    local stopInProfit = validNumber(brokerStop) and validNumber(snapshot.entryPrice)
        and (side == "B" and brokerStop > snapshot.entryPrice or side == "S" and brokerStop < snapshot.entryPrice)
    local setupText = string.upper(tostring(snapshot.signalSetup or snapshot.entrySetup or "UNKNOWN"))
    local function setupFlag(fragment)
        return string.find(setupText, fragment, 1, true) ~= nil and 1.0 or 0.0
    end
    return {
        bias=1.0,
        currentR=clamp((tonumber(currentR) or 0) / 3.0, -1.0, 1.0),
        mfeR=clamp(mfeR / 3.0, 0.0, 1.0),
        maeR=clamp(maeR / 3.0, 0.0, 1.0),
        givebackR=clamp(givebackR / 3.0, -1.0, 1.0),
        barsHeld=clamp((tonumber(snapshot.lastBarsHeld) or 0) / 40.0, 0.0, 1.0),
        priceFastEMA=signedATR(close - Context.emaFast),
        priceMediumEMA=signedATR(close - Context.emaMed),
        priceSlowEMA=signedATR(close - Context.emaSlow),
        fastMediumEMAGap=signedATR(Context.emaFast - Context.emaMed),
        mediumSlowEMAGap=signedATR(Context.emaMed - Context.emaSlow),
        fastEMASlope=signedATR(tonumber(Context.emaFastSlope) or 0),
        mediumEMASlope=signedATR(tonumber(Context.emaMedSlope) or 0),
        vwapAlignment=clamp(sign * (tonumber(Context.vwapDistATR) or 0) / 3.0, -1.0, 1.0),
        momentumAlignment=clamp(sign * (tonumber(Context.momentumATR) or 0) / 3.0, -1.0, 1.0),
        dmiAlignment=clamp(sign * ((tonumber(Context.plusDirection) or 0)
            - (tonumber(Context.minusDirection) or 0)) / 40.0, -1.0, 1.0),
        adxStrength=clamp(((tonumber(Context.adx) or 18) - 18) / 22.0, -1.0, 1.0),
        emaStackAligned=stack,
        breakEvenActive=breakEven and 1.0 or 0.0,
        stopInProfit=stopInProfit and 1.0 or 0.0,
        setupPullback=setupFlag("PULLBACK"), setupBreakout=setupFlag("BREAKOUT"),
        setupContinuation=setupFlag("CONTINUATION"), setupRange=setupFlag("RANGE"),
        setupFade=setupFlag("FADE"), setupReversal=setupFlag("REVERSAL")
    }
end

function SmartAI.predictExit(features)
    if Cfg.MLMode == "OFF" or Rt.ML == nil or features == nil then return nil, 0 end
    Rt.ML.exitWeights = Rt.ML.exitWeights or {}
    local z = 0.0
    for i = 1, #Const.ML_EXIT_FEATURE_NAMES do
        local name = Const.ML_EXIT_FEATURE_NAMES[i]
        z = z + (Rt.ML.exitWeights[name] or 0.0) * (features[name] or 0.0)
    end
    z = clamp(z, -30.0, 30.0)
    return 1.0 / (1.0 + math.exp(-z)), Rt.ML.exitSamples or 0
end

function SmartAI.forgetExitTradeState(tradeId)
    if tradeId == nil then return end
    local target = Rt.tradeExitFeatures[tradeId] or Rt.tradeExitFeatures[tostring(tradeId)]
    local ids = {[tradeId]=true, [tostring(tradeId)]=true}
    for id, features in pairs(Rt.tradeExitFeatures) do
        if target ~= nil and features == target then ids[id] = true end
    end
    for id, root in pairs(Rt.tradeLineageRoot) do
        if tostring(root) == tostring(tradeId) then ids[id] = true end
    end
    for id in pairs(ids) do
        Rt.tradeExitFeatures[id] = nil
        Rt.tradeLineageRoot[id] = nil
        runtimePut(tradeStateKey(id, "lineageRoot"), "")
        runtimePut(tradeStateKey(id, "exitFeatureSchema"), "")
        runtimePut(tradeStateKey(id, "exitNamespace"), "")
        runtimePut(tradeStateKey(id, "exitFeatures"), "")
    end
end

function SmartAI.learnExitClosedTrade(tradeId, netPL, eventId)
    if Cfg.MLMode == "OFF" or Rt.ML == nil or tradeId == nil or not validNumber(netPL) then return false end
    Rt.ML.exitWeights = Rt.ML.exitWeights or {}
    local features = Rt.tradeExitFeatures[tradeId] or Rt.tradeExitFeatures[tostring(tradeId)]
    if features == nil then
        loadTradeMetadata(tradeId)
        features = Rt.tradeExitFeatures[tradeId] or Rt.tradeExitFeatures[tostring(tradeId)]
    end
    if features == nil then
        debug("SMART AI EXIT LEARN SKIPPED | event=" .. tostring(eventId) .. " exit snapshot unavailable")
        return false
    end
    if abs(netPL) <= Const.LOSS_EPSILON then
        Rt.ML.exitSkipped = (Rt.ML.exitSkipped or 0) + 1
        SmartAI.forgetExitTradeState(tradeId)
        mlPersistState()
        debug("SMART AI EXIT LEARN SKIPPED | event=" .. tostring(eventId) .. " break-even outcome")
        return false
    end
    local target = netPL > Const.LOSS_EPSILON and 1.0 or 0.0
    local probability = SmartAI.predictExit(features)
    local sampleWeight = 1.0
    if Cfg.MLBalanceClasses then
        local total = max(2.0, (Rt.ML.exitSamples or 0) + 2.0)
        local classCount = target == 1.0 and max(1.0, (Rt.ML.exitWins or 0) + 1.0)
            or max(1.0, (Rt.ML.exitLosses or 0) + 1.0)
        sampleWeight = clamp(total / (2.0 * classCount), 0.5, 3.0)
    end
    local gradientError = (target - probability) * sampleWeight
    local lr = Cfg.MLLearningRate or 0.05
    if (Rt.ML.exitSamples or 0) > (Cfg.MLMinSamples or 50) * 3 then lr = lr * 0.7 end
    for i = 1, #Const.ML_EXIT_FEATURE_NAMES do
        local name = Const.ML_EXIT_FEATURE_NAMES[i]
        local weight = Rt.ML.exitWeights[name] or 0.0
        local penalty = name == "bias" and 0.0 or Cfg.MLL2 * weight
        weight = weight + lr * (gradientError * (features[name] or 0.0) - penalty)
        Rt.ML.exitWeights[name] = clamp(weight, -Cfg.MLMaxAbsWeight, Cfg.MLMaxAbsWeight)
    end
    Rt.ML.exitSamples = (Rt.ML.exitSamples or 0) + 1
    if target == 1.0 then Rt.ML.exitWins = (Rt.ML.exitWins or 0) + 1
    else Rt.ML.exitLosses = (Rt.ML.exitLosses or 0) + 1 end
    mlPersistState()
    debug(string.format("SMART AI EXIT UPDATED | event=%s label=%s preP=%.1f%% n=%d wins=%d losses=%d featureSchema=%d features=%d observeOnly=Y",
        tostring(eventId), target == 1.0 and "WIN" or "LOSS", probability * 100.0,
        Rt.ML.exitSamples, Rt.ML.exitWins, Rt.ML.exitLosses,
        Const.ML_EXIT_FEATURE_SCHEMA, #Const.ML_EXIT_FEATURE_NAMES))
    SmartAI.forgetExitTradeState(tradeId)
    return true
end

function SmartAI.forgetTradeState(tradeId)
    if tradeId == nil then return end
    local target = Rt.tradeMLFeatures[tradeId]
    for id, features in pairs(Rt.tradeMLFeatures) do
        if id == tradeId or (target ~= nil and features == target) then
            Rt.tradeMLFeatures[id] = nil
        end
    end
    runtimePut(tradeStateKey(tradeId, "mlFeatureSchema"), "")
    runtimePut(tradeStateKey(tradeId, "mlNamespace"), "")
    runtimePut(tradeStateKey(tradeId, "mlFeatures"), "")
    SmartAI.forgetExitTradeState(tradeId)
end

function SmartAI.pushRecentOutcome(label)
    if Rt.ML == nil then return end
    local window = Rt.ML.recentWindow
    if type(window) ~= "table" then
        window = {}
        Rt.ML.recentWindow = window
    end
    window[#window + 1] = label
    local maxLen = tonumber(Cfg.MLRecentWindow) or 30
    if maxLen < 5 then maxLen = 5 end
    while #window > maxLen do table.remove(window, 1) end
    local sum = 0.0
    for i = 1, #window do sum = sum + window[i] end
    Rt.ML.calibratedWinRate = sum / #window
    if label >= 0.5 then
        Rt.ML.recentWins = (Rt.ML.recentWins or 0) + 1
    else
        Rt.ML.recentLosses = (Rt.ML.recentLosses or 0) + 1
    end
end

function SmartAI.learnClosedTrade(tradeId, netPL, eventId, netR)
    if Cfg.MLMode == "OFF" or Rt.ML == nil or tradeId == nil or not validNumber(netPL) then return false end
    local features = Rt.tradeMLFeatures[tradeId]
    if features == nil then features = Rt.tradeMLFeatures[tostring(tradeId)] end
    -- A terminal restart can leave a completed trade with only its persisted
    -- entry vector available. Recover that exact, namespace-checked vector
    -- before deciding that the training sample is unavailable.
    if features == nil then
        loadTradeMetadata(tradeId)
        features = Rt.tradeMLFeatures[tradeId] or Rt.tradeMLFeatures[tostring(tradeId)]
    end
    if features == nil then
        debug("SMART AI LEARN SKIPPED | event=" .. tostring(eventId) .. " entry features unavailable (recovered trade)")
        return false
    end
    if abs(netPL) <= Const.LOSS_EPSILON then
        Rt.ML.skipped = (Rt.ML.skipped or 0) + 1
        SmartAI.forgetTradeState(tradeId)
        mlPersistState()
        debug("SMART AI LEARN SKIPPED | event=" .. tostring(eventId) .. " break-even outcome")
        return false
    end
    local target = netPL > Const.LOSS_EPSILON and 1.0 or 0.0
    local probability = SmartAI.logisticProbability(features)
    local sampleWeight = 1.0
    if Cfg.MLBalanceClasses then
        local total = max(2.0, (Rt.ML.samples or 0) + 2.0)
        local classCount = target == 1.0 and max(1.0, (Rt.ML.wins or 0) + 1.0)
            or max(1.0, (Rt.ML.losses or 0) + 1.0)
        sampleWeight = clamp(total / (2.0 * classCount), 0.5, 3.0)
    end
    -- netR is computed from aggregate closed cash P/L / original cash risk.
    -- Price distance alone is not a currency denominator. Unknown risk uses
    -- neutral sample weight rather than inventing a conversion.
    if Cfg.MLWeightByR and validNumber(netR) then
        sampleWeight = sampleWeight * clamp(0.5 + abs(netR) * 0.5, 0.5, 2.5)
    end
    local gradientError = (target - probability) * sampleWeight
    local lr = Cfg.MLLearningRate or 0.05
    if (Rt.ML.samples or 0) > (Cfg.MLMinSamples or 50) * 3 then
        lr = lr * 0.7
    end
    for i = 1, #ML_FEATURE_NAMES do
        local name = ML_FEATURE_NAMES[i]
        local weight = Rt.ML.weights[name] or 0.0
        local penalty = name == "bias" and 0.0 or Cfg.MLL2 * weight
        weight = weight + lr * (gradientError * (features[name] or 0.0) - penalty)
        Rt.ML.weights[name] = clamp(weight, -Cfg.MLMaxAbsWeight, Cfg.MLMaxAbsWeight)
    end
    Rt.ML.samples = (Rt.ML.samples or 0) + 1
    if target == 1.0 then Rt.ML.wins = (Rt.ML.wins or 0) + 1
    else Rt.ML.losses = (Rt.ML.losses or 0) + 1 end
    SmartAI.pushRecentOutcome(target)
    SmartAI.forgetTradeState(tradeId)
    mlPersistState()
    debug(string.format("SMART AI UPDATED | event=%s label=%s preP=%.1f%% n=%d wins=%d losses=%d cal=%.1f%% featureSchema=%d features=%d",
        tostring(eventId), target == 1.0 and "WIN" or "LOSS", probability * 100.0,
        Rt.ML.samples, Rt.ML.wins, Rt.ML.losses,
        (Rt.ML.calibratedWinRate or 0.5) * 100.0, Const.ML_FEATURE_SCHEMA, #ML_FEATURE_NAMES))
    return true
end

local function checkReady(tableName)
    if Rt.Account == "TESTACC_ID" then return true end
    return core.host:execute("isTableFilled", tableName)
end

-- =========================
-- Parameters
-- =========================
function Init()
    strategy:name(STRATEGY_NAME)
    strategy:description(STRATEGY_NAME .. ": operator-selectable timeframe, clean/HTF entry policies, unified volatility/range geometry, confirmed-close lifecycle accounting, broker protection, and original management stack.")
    strategy:type(core.Both)
    strategy:setTag("NonOptimizableParameters", "Account,CustomID,ShowDebug,ShowCleanDiagnostics,CompactDiagnostics,ShowAlerts,WriteCSVLogFile,CSVLogFile,MLResetModel")

    strategy.parameters:addGroup("Price / Timeframes")
    strategy.parameters:addBoolean("BidOrAsk", "Price Type", "", true)
    strategy.parameters:setFlag("BidOrAsk", core.FLAG_BIDASK)
    strategy.parameters:addString("TF", "Trading Timeframe", "Choose any supported FXCM/Indicore BAR timeframe. Default m1. Bar-based controls (cooldown, max bars, setup reuse, lookbacks) are measured in the selected timeframe.", "m1")
    strategy.parameters:setFlag("TF", core.FLAG_PERIODS)
    strategy.parameters:addBoolean("UseHTF", "Use Higher-Timeframe Confirmation", "Optional higher-timeframe confirmation. Disabled in the GER30 M1 replay profile; enable only if you want the HTF gate.", false)
    strategy.parameters:addString("HTF", "Higher Timeframe", "", "m15")
    strategy.parameters:setFlag("HTF", core.FLAG_PERIODS)
    strategy.parameters:addInteger("HTFMaxAgeMinutes", "Max HTF Data Age, minutes", "", 20, 1, 1440)
    strategy.parameters:addString("HTFMAMethod", "HTF MA Method", "Moving average used only by the higher-timeframe opposition filter", "EMA")
    strategy.parameters:addStringAlternative("HTFMAMethod", "EMA (Exponential)", "", "EMA")
    strategy.parameters:addStringAlternative("HTFMAMethod", "SMA (Simple / FXCM MVA)", "", "MVA")
    strategy.parameters:addInteger("HTFMAPeriod", "HTF MA Period", "", 21, 2, 500)
    strategy.parameters:addInteger("HTFATRPeriod", "HTF ATR Period", "", 14, 2, 200)
    strategy.parameters:addDouble("HTFOppositionMinGapATR", "HTF Minimum Opposing MA Gap, ATR", "Opposition requires the HTF close to clear this normalized distance beyond its MA", 0.15, 0, 5)
    strategy.parameters:addDouble("HTFOppositionMinSlopeATR", "HTF Minimum Opposing MA Slope, ATR", "Opposition also requires the one-bar HTF MA slope to exceed this normalized magnitude", 0.02, 0, 1)
    strategy.parameters:addBoolean("HTFAllowNeutral", "Allow Neutral HTF", "Allow entries when HTF distance and slope do not confirm either direction", true)
    strategy.parameters:addString("HTFOppositionMode", "HTF Opposition Mode", "Block entries when fresh higher-timeframe direction opposes the trade", "BLOCK")
    strategy.parameters:addStringAlternative("HTFOppositionMode", "Evidence only (v7 default)", "", "EVIDENCE")
    strategy.parameters:addStringAlternative("HTFOppositionMode", "Hard block on opposition", "", "BLOCK")

    strategy.parameters:addGroup("Indicator Periods")
    strategy.parameters:addString("MAMethod", "Main MA Method", "Select the native FXCM moving average used for fast, medium, and slow chart lines", "EMA")
    strategy.parameters:addStringAlternative("MAMethod", "EMA (Exponential)", "", "EMA")
    strategy.parameters:addStringAlternative("MAMethod", "SMA (Simple / FXCM MVA)", "", "MVA")
    strategy.parameters:addInteger("FastPeriod", "Fast MA Period", "", 9, 2, 200)
    strategy.parameters:addInteger("MediumPeriod", "Medium MA Period", "", 20, 3, 400)
    strategy.parameters:addInteger("SlowPeriod", "Slow MA Period", "", 50, 5, 1000)
    strategy.parameters:addInteger("RSIPeriod", "RSI Period", "", 14, 2, 200)
    strategy.parameters:addInteger("ATRPeriod", "ATR Period", "", 14, 2, 200)
    strategy.parameters:addInteger("ADXPeriod", "ADX Period", "", 14, 2, 200)
    strategy.parameters:addInteger("BBPeriod", "Band Period", "", 20, 5, 300)
    strategy.parameters:addInteger("SwingPeriod", "Swing Lookback", "", 20, 5, 300)
    strategy.parameters:addInteger("StatsPeriod", "Adaptive Statistics Lookback", "", 50, 20, 500)
    strategy.parameters:addInteger("MomentumPeriod", "Momentum Lookback", "", 3, 1, 100)

    strategy.parameters:addGroup("Confirmed Market Structure")
    strategy.parameters:addInteger("StructurePivotStrength", "Pivot Confirmation Bars", "Bars required on both sides of a pivot; confirmation is delayed by this many closed bars to prevent look-ahead", 2, 1, 10)
    strategy.parameters:addDouble("StructureMinPivotATR", "Min Pivot Size, ATR", "Ignore micro pivots smaller than this ATR multiple vs prior same-side pivot (0 = off)", 0.25, 0, 3)
    strategy.parameters:addBoolean("UseStructureDirectionWeight", "Use HH/HL/LH/LL Direction Weight", "Add the configured weight only when confirmed HH+HL supports uptrend or LH+LL supports downtrend", true)
    strategy.parameters:addDouble("StructureDirectionWeight", "Market Structure Direction Weight", "Points added to the matching directional trend regime; never bypasses entry, HTF, risk, session, spread, or structure gates", 0.75, 0, 2)
    strategy.parameters:addBoolean("UseEnhancedStructure", "Enhanced Structure Engine", "Scale the optional structure direction weight by confirmed-structure confidence and phase", true)
    strategy.parameters:addInteger("StructureMaxPivotAgeBars", "Maximum Structure Pivot Age, bars", "Freshness applies to every high/low, including transition states; expired labels do not contribute entry evidence", 50, 5, 500)
    strategy.parameters:addBoolean("OpposingCHOCHHardBlock", "Block Entries on Opposing CHOCH", "When enabled, a confirmed change-of-character against the candidate side is a hard entry blocker (in addition to the structure evidence penalty)", false)

    strategy.parameters:addGroup("Regime / Signal Thresholds")
    strategy.parameters:addDouble("RegimeThreshold", "Minimum Regime Score", "Legacy regime classification and v7 evidence input; the final v7 hard entry threshold is Minimum Probability Evidence Score", 4.0, 0, 10)
    strategy.parameters:addDouble("ReversalThreshold", "Minimum Reversal Regime Score", "Legacy reversal classification and v7 evidence input; the final v7 hard entry threshold is Minimum Probability Evidence Score", 6.5, 0, 10)
    strategy.parameters:addDouble("RegimeConfidenceMargin", "Minimum Winning-Regime Margin", "Legacy regime-classification margin retained as v7 evidence; a conflict is diagnostic evidence, not by itself a hard v7 entry blocker", 1.0, 0, 5)
    strategy.parameters:addDouble("TrendBreakoutConfidenceBonus", "Trend + Breakout Agreement Bonus", "Small confidence-only bonus when both same-direction regimes independently qualify; does not add entry-quality points or bypass structure", 0.50, 0, 2)

    strategy.parameters:addGroup("Trade Type / Directional Quality Controls")
    strategy.parameters:addString("TradeTypeProfile", "Trade Type Profile", "TREND_FOCUS allows trend and breakout setups; range and fade entries are disabled in this profile", "TREND_FOCUS")
    strategy.parameters:addStringAlternative("TradeTypeProfile", "Auto from market state (recommended)", "", "AUTO_SMART")
    strategy.parameters:addStringAlternative("TradeTypeProfile", "Trend + breakout focus", "", "TREND_FOCUS")
    strategy.parameters:addStringAlternative("TradeTypeProfile", "Fade / mean-reversion focus", "", "FADE_FOCUS")
    strategy.parameters:addStringAlternative("TradeTypeProfile", "Manual switches only", "", "MANUAL")
    strategy.parameters:addBoolean("AllowTrendTrades", "Allow Trend Trades", "TRENDING_UP / TRENDING_DOWN (continuation & pullback)", true)
    strategy.parameters:addBoolean("AllowBreakoutTrades", "Allow Breakout Trades", "BREAKOUT_UP / BREAKOUT_DOWN after compression", true)
    strategy.parameters:addBoolean("AllowRangeTrades", "Allow Range Trades", "CHOPPY_RANGE edge mean-reversion", false)
    strategy.parameters:addBoolean("AllowReversalTrades", "Allow Reversal Trades", "Generic REVERSAL_BULL / REVERSAL_BEAR (broader than VWAP fade)", false)
    strategy.parameters:addBoolean("AllowVWAPFadeTrades", "Allow VWAP Fade Trades", "Permit VWAP fades in both clean and legacy entry paths; Enable VWAP Fade Entries must also be on", false)

    strategy.parameters:addGroup("Smart Market State AI")
    strategy.parameters:addBoolean("UseSmartMarketState", "Use Smart Market State AI", "Multi-factor market-state classifier with confidence and hysteresis; improves state read accuracy (not a price oracle)", true)
    strategy.parameters:addDouble("SmartStateMinConfidence", "Min State Confidence to Trade", "Block new entries when state confidence is below this (0-100). 0 disables the gate", 48.0, 0, 100)
    strategy.parameters:addInteger("SmartStateMaxHoldBars", "Maximum State Hysteresis Hold, bars", "A persistent new state replaces an old state after this many closed bars", 3, 1, 20)
    strategy.parameters:addDouble("SmartStateHysteresis", "State Flip Hysteresis", "Require this much extra confidence to flip away from a held state (reduces flip-flop)", 12.0, 0, 40)

    strategy.parameters:addGroup("VWAP Fade Module")
    strategy.parameters:addBoolean("UseVWAPFade", "Enable VWAP Fade Entries", "Mean-revert when price is stretched from VWAP with RSI exhaustion and rejection. With the clean engine enabled this exposes dedicated VWAP_FADE_LONG / VWAP_FADE_SHORT setups; independent of generic Allow Reversal Trades", false)
    strategy.parameters:addDouble("VWAPFadeMinATR", "Min VWAP Stretch for Fade, ATR", "GER30 sample: 2.0 ATR stretch; partial snapback common, full cross rare", 2.0, 0.5, 10)
    strategy.parameters:addDouble("VWAPFadeRSIHigh", "Fade Short when RSI >=", "Sell fade only with overbought RSI at upper VWAP stretch", 70.0, 50, 90)
    strategy.parameters:addDouble("VWAPFadeRSILow", "Fade Long when RSI <=", "Buy fade only with oversold RSI at lower VWAP stretch", 30.0, 10, 50)
    strategy.parameters:addBoolean("VWAPFadeRequireRejection", "Require Rejection Candle", "Wick rejection in fade direction (bullish rejection for long fade, bearish for short)", true)
    strategy.parameters:addDouble("VWAPFadeMaxADX", "Max ADX for Fade", "Skip fades when ADX is extremely strong (0 = ignore). Soft guard against fading a runaway trend", 45.0, 0, 100)
    strategy.parameters:addBoolean("RequireDominantDirectionalRegime", "Require Dominant Directional Regime", "For trend or breakout entries, require the selected directional regime score to exceed competing directional/structure regimes (range, opposite trend, reversal). Volatility environment scores are not competitors", false)
    strategy.parameters:addDouble("MinimumTrendADX", "Minimum Trend ADX", "Hard minimum ADX for TRENDING_UP and TRENDING_DOWN entries; breakout entries retain their existing breakout ADX rules", 15.0, 0, 100)
    strategy.parameters:addBoolean("RequireDirectionalDMIAlignment", "Require Directional DMI Alignment", "For trend and breakout entries, require DI+ > DI- for LONG and DI- > DI+ for SHORT", true)

    strategy.parameters:addGroup("Activity / Trade Frequency")
    strategy.parameters:addString("ActivityProfile", "Activity Profile", "ACTIVE/AGGRESSIVE presets were tuned for M1. By default non-M1 timeframes use BALANCED operator inputs unless Apply Activity Profile on Any TF is enabled.", "AGGRESSIVE")
    strategy.parameters:addStringAlternative("ActivityProfile", "Balanced (operator inputs)", "", "BALANCED")
    strategy.parameters:addStringAlternative("ActivityProfile", "Active (more M1 trades)", "", "ACTIVE")
    strategy.parameters:addStringAlternative("ActivityProfile", "Aggressive (highest frequency)", "", "AGGRESSIVE")
    strategy.parameters:addBoolean("ApplyActivityProfileAllTF", "Apply Activity Profile on Any TF", "Off (recommended default): non-M1 uses BALANCED operator inputs. On: applies ACTIVE/AGGRESSIVE preset overrides on the selected bar timeframe too.", false)

    strategy.parameters:addGroup("Probability Edge Engine")
    strategy.parameters:addDouble("ProbabilityScoreMin", "Minimum Probability Evidence Score", "Base score; ActivityProfile ACTIVE/AGGRESSIVE may lower the effective bar at Prepare", 52.0, 0, 100)
    strategy.parameters:addDouble("ProbabilityEdgeMin", "Minimum LONG/SHORT Evidence Edge", "Base edge; ActivityProfile may lower. GER30 M1 noise ~ATR", 5.0, 0, 100)
    strategy.parameters:addBoolean("ProbabilityRequireHTFData", "Require Fresh HTF Data", "When HTF is enabled, block entries if the higher-timeframe data is missing or stale", true)
    strategy.parameters:addBoolean("UseSmartEvidence", "Use Smart Evidence Engine", "v8.4 ON: coherence, agreement bonus, State AI alignment, trade-type fit, adaptive score/edge", true)
    strategy.parameters:addBoolean("RequireEvidenceCoherence", "Require Directional Bucket Minimums", "Trend/breakout must clear min direction/structure/location/momentum buckets", true)
    strategy.parameters:addDouble("MinBucketDirection", "Min Direction Bucket", "Hard minimum direction/regime evidence for trend and breakout when coherence is required", 6.0, 0, 20)
    strategy.parameters:addDouble("MinBucketStructure", "Min Structure Bucket", "Hard minimum confirmed-structure evidence for trend and breakout when coherence is required", 3.0, 0, 20)
    strategy.parameters:addDouble("MinBucketLocation", "Min Location Bucket", "Hard minimum entry-location evidence for trend and breakout when coherence is required", 4.0, 0, 20)
    strategy.parameters:addDouble("MinBucketMomentum", "Min Momentum Bucket", "Hard minimum momentum/trigger evidence for trend and breakout when coherence is required", 3.0, 0, 15)
    strategy.parameters:addBoolean("ProbabilityUseStateAI", "Probability Uses State AI", "Boost/penalize evidence and required score from Smart Market State confidence and bias alignment", true)
    strategy.parameters:addDouble("StateAIScoreBoostMax", "Max State-AI Score Boost", "Max points added when state bias aligns and confidence is high", 6.0, 0, 15)
    strategy.parameters:addDouble("StateAILowConfScoreAdd", "Extra Required if State Conf Low", "Added to required score when state confidence is weak", 4.0, 0, 20)
    strategy.parameters:addDouble("SmartHTFOpposedScoreAdd", "Extra Score Required if HTF Opposed", "Added to ProbabilityScoreMin when HTF is confirmed opposed and opposition mode is EVIDENCE", 2.0, 0, 30)
    strategy.parameters:addDouble("SmartHTFOpposedEdgeAdd", "Extra Edge Required if HTF Opposed", "Added to ProbabilityEdgeMin when the leading side faces confirmed HTF opposition under EVIDENCE mode", 2.0, 0, 30)
    strategy.parameters:addDouble("SmartThinMarginScoreAdd", "Extra Score Required if Regime Margin Thin", "Added when the effective regime margin is below RegimeConfidenceMargin", 1.0, 0, 20)
    strategy.parameters:addDouble("SmartHighVolScoreAdd", "Extra Score Required in High Volatility", "Added when the high-volatility regime score is elevated", 1.0, 0, 20)
    strategy.parameters:addDouble("SmartAgreementBonusMax", "Max Multi-Factor Agreement Bonus", "Bonus points when direction, structure, location, momentum and HTF are simultaneously strong", 5.0, 0, 15)
    strategy.parameters:addDouble("ProbabilityPullbackMaxEntryGapATR", "Probability Pullback Max Entry Gap, ATR", "Hard limit: signal close must stay within this ATR of the fast MA. Lower = less buy-high/sell-low. Combined with TrendPullbackMaxCloseATR (stricter of the two wins).", 0.60, 0.10, 3.0)
    strategy.parameters:addDouble("VWAPStretchATR", "VWAP Stretch, ATR", "", 5.0, 0.2, 10)
    strategy.parameters:addDouble("TrendMaxExtensionATR", "Trend Maximum VWAP Extension, ATR", "", 6.0, 0.5, 10)
    strategy.parameters:addString("TrendEntryMode", "Trend Entry Mode", "LEGACY_CONTINUATION uses closed-bar near-MA or momentum entries; FAST_MA_PULLBACK is stricter", "LEGACY_CONTINUATION")
    strategy.parameters:addStringAlternative("TrendEntryMode", "Fast-MA Pullback / Reclaim", "", "FAST_MA_PULLBACK")
    strategy.parameters:addStringAlternative("TrendEntryMode", "Legacy Near-MA or Momentum", "", "LEGACY_CONTINUATION")
    strategy.parameters:addInteger("TrendPullbackLookbackBars", "Fast-MA Pullback Lookback, bars", "The retest must occur on the signal bar or within this many completed bars", 8, 1, 20)
    strategy.parameters:addDouble("TrendPullbackTouchATR", "Fast-MA Retest Tolerance, ATR", "How close a candle must trade to the fast MA to count as a retest", 0.30, 0, 1.5)
    strategy.parameters:addDouble("TrendPullbackMaxCloseATR", "Maximum Signal Close from Fast MA, ATR", "Prevents buy-high / sell-low: signal close must stay within this ATR of the fast MA after reclaim", 0.55, 0.05, 3)
    strategy.parameters:addDouble("PullbackMinRetraceATR", "Minimum Pullback Retracement, ATR", "Shared pullback evidence and strict geometry; validate settings on your feed", 0.2, 0, 2)
    strategy.parameters:addInteger("PullbackMaxAgeBars", "Maximum Pullback Age, bars", "Shared pullback evidence and strict geometry; validate settings on your feed", 5, 1, 20)
    strategy.parameters:addDouble("PullbackMinReclaimATR", "Minimum MA Reclaim, ATR", "Shared pullback evidence and strict geometry; validate settings on your feed", 0.05, 0.01, 1)
    strategy.parameters:addDouble("PullbackMinBodyATR", "Minimum Resumption Body, ATR", "Shared pullback evidence and strict geometry; validate settings on your feed", 0.1, 0.01, 2)
    strategy.parameters:addDouble("PullbackMaxAdverseATR", "Invalidate on Adverse Close, ATR", "Shared pullback evidence and strict geometry; validate settings on your feed", 0.75, 0.1, 3)
    strategy.parameters:addDouble("PullbackMaxVWAPATR", "Pullback VWAP Extension Limit, ATR", "Shared pullback evidence and strict geometry; validate settings on your feed", 1.25, 0.1, 6)
    strategy.parameters:addDouble("PullbackMaxLongRSI", "Pullback Long Maximum RSI", "Shared pullback evidence and strict geometry; validate settings on your feed", 68, 50, 90)
    strategy.parameters:addDouble("PullbackMinShortRSI", "Pullback Short Minimum RSI", "Shared pullback evidence and strict geometry; validate settings on your feed", 32, 10, 50)
    strategy.parameters:addBoolean("UseEarlyTrendBreakout", "Allow Bounded Early Trend Breakout", "When trend and breakout agree directionally, permit the first swing-break entry only inside strict DMI, momentum, ADX, fast-MA, and VWAP limits", true)
    strategy.parameters:addDouble("EarlyBreakoutMinMomentumATR", "Early Breakout Minimum Momentum, ATR", "Absolute directional momentum required for the bounded early entry", 0.75, 0.10, 5)
    strategy.parameters:addDouble("EarlyBreakoutMinDMIRatio", "Early Breakout Minimum DMI Ratio", "Winning directional DI divided by opposing DI", 1.20, 1.0, 5)
    strategy.parameters:addDouble("EarlyBreakoutMinADX", "Early Breakout Minimum ADX", "Rejects weak swing breaks even when trend and breakout scores agree", 18.0, 0, 100)
    strategy.parameters:addDouble("EarlyBreakoutMaxFastMAGapATR", "Early Breakout Maximum Close from Fast MA, ATR", "Prevents chasing a breakout already too far from the fast MA", 1.50, 0.10, 3)
    strategy.parameters:addDouble("EarlyBreakoutMaxVWAPExtensionATR", "Early Breakout Maximum VWAP Extension, ATR", "Directional maximum distance from VWAP for the first-break entry", 3.50, 0.25, 5)
    strategy.parameters:addDouble("BreakoutMaxExtensionATR", "Breakout Maximum VWAP Extension, ATR", "", 2.5, 0.5, 10)
    strategy.parameters:addDouble("RangeEdgeFraction", "Range Entry Edge Fraction", "Longs must be in the bottom fraction and shorts in the top fraction of the prior swing range", 0.35, 0.10, 0.49)
    strategy.parameters:addDouble("BreakoutATRMin", "Minimum Breakout Displacement, ATR", "", 0.25, 0, 5)
    strategy.parameters:addInteger("BreakoutCompressionLookback", "Breakout Compression Lookback", "Bars immediately preceding the breakout bar", 12, 3, 100)
    strategy.parameters:addDouble("CompressionATRPctMax", "Compression Maximum Prior ATR Percentile", "", 0.45, 0.05, 0.95)
    strategy.parameters:addDouble("CompressionBBPctMax", "Compression Maximum Prior BB Width Percentile", "", 0.40, 0.05, 0.95)
    strategy.parameters:addDouble("CompressionRangeATRMax", "Compression Maximum Lookback Range, ATR", "", 4.0, 0.5, 20)
    strategy.parameters:addDouble("LargeCandleATR", "Reject Candle Larger Than ATR x", "GER30: reject extreme spikes only (p95 range/ATR ~2)", 2.5, 0.5, 10)

    strategy.parameters:addGroup("Entry Engine Selection / Legacy V2")
    strategy.parameters:addString("EntryEngineMode", "Entry Engine Mode", "CLEAN uses the deterministic clean setup engine. LEGACY_V1 preserves the original probability/regime path. LEGACY_V2 uses simplified state -> setup -> evidence -> gates. HYBRID_CONFIRM trades Clean candidates only when Legacy V2 evidence confirms them. SHADOW trades Clean while logging Legacy V2 decisions.", "CLEAN")
    strategy.parameters:addStringAlternative("EntryEngineMode", "Clean engine", "", "CLEAN")
    strategy.parameters:addStringAlternative("EntryEngineMode", "Legacy v1 (original)", "", "LEGACY_V1")
    strategy.parameters:addStringAlternative("EntryEngineMode", "Legacy v2 simplified evidence", "", "LEGACY_V2")
    strategy.parameters:addStringAlternative("EntryEngineMode", "Hybrid: Clean + Legacy v2 confirmation", "", "HYBRID_CONFIRM")
    strategy.parameters:addStringAlternative("EntryEngineMode", "Shadow: Clean trades, Legacy v2 logs", "", "SHADOW")
    strategy.parameters:addBoolean("OnlyEMAPullbacks", "Only EMA Pullback Entries", "When enabled, all entry engines reject breakout, continuation, range and fade entries. CLEAN-family engines require their EMA9/EMA20 touch-and-reclaim trigger; LEGACY_V1 uses its FAST_MA_PULLBACK rules.", true)
    strategy.parameters:addDouble("LegacyV2TrendMinEvidence", "Legacy V2 Trend/Breakout Minimum Evidence", "Single 0-100 threshold for EMA pullback, continuation and breakout candidates", 60.0, 0, 100)
    strategy.parameters:addDouble("LegacyV2RangeMinEvidence", "Legacy V2 Range Minimum Evidence", "Single 0-100 threshold for RANGE mean-reversion candidates", 55.0, 0, 100)
    strategy.parameters:addDouble("LegacyV2FadeMinEvidence", "Legacy V2 VWAP Fade Minimum Evidence", "Single 0-100 threshold for VWAP_FADE_LONG / VWAP_FADE_SHORT candidates", 55.0, 0, 100)
    strategy.parameters:addDouble("LegacyV2MinDirection", "Legacy V2 Minimum Direction Bucket", "Hard minimum for trend/breakout; RANGE/VWAP fade use setup-specific location/trigger rules instead", 10.0, 0, 20)
    strategy.parameters:addDouble("LegacyV2MinStructure", "Legacy V2 Minimum Structure Bucket", "Hard minimum confirmed-structure evidence", 8.0, 0, 20)
    strategy.parameters:addDouble("LegacyV2MinLocation", "Legacy V2 Minimum Location Bucket", "Hard minimum entry-location evidence", 8.0, 0, 20)
    strategy.parameters:addDouble("LegacyV2MinMomentum", "Legacy V2 Minimum Momentum Bucket", "Hard minimum trigger/momentum evidence", 6.0, 0, 15)
    strategy.parameters:addString("LegacyV2SmartStatePolicy", "Legacy V2 Smart State Policy", "OFF ignores Smart Market State in Legacy V2. EVIDENCE adds/subtracts bounded context points only. STRICT also requires the configured confidence floor.", "EVIDENCE")
    strategy.parameters:addStringAlternative("LegacyV2SmartStatePolicy", "Off", "", "OFF")
    strategy.parameters:addStringAlternative("LegacyV2SmartStatePolicy", "Evidence only", "", "EVIDENCE")
    strategy.parameters:addStringAlternative("LegacyV2SmartStatePolicy", "Strict confidence + evidence", "", "STRICT")
    strategy.parameters:addDouble("LegacyV2SmartStateBonus", "Legacy V2 Smart State Context Points", "Maximum bounded bonus/penalty from aligned/opposed Smart Market State; never changes trade-family permissions", 5.0, 0, 15)
    strategy.parameters:addDouble("LegacyV2StrictMinConfidence", "Legacy V2 Strict State Minimum Confidence", "Used only when Legacy V2 Smart State Policy=STRICT", 60.0, 0, 100)

    strategy.parameters:addGroup("v9.1 Clean Entry Engine")
    strategy.parameters:addBoolean("UseCleanV91EntryEngine", "Compatibility: Old Clean Engine Switch", "Retained for old templates. Entry Engine Mode is authoritative in v9.2.21.", true)
    strategy.parameters:addString("CleanPullbackMode", "Clean Pullback Mode", "UPGRADED uses confirmed EMA9/20 direction, remembered touches and dedicated pullback quality. CLASSIC retains the previous CLEAN rules. Applies to CLEAN/SHADOW/HYBRID pullback selection only.", "UPGRADED")
    strategy.parameters:addStringAlternative("CleanPullbackMode", "Upgraded pullbacks", "", "UPGRADED")
    strategy.parameters:addStringAlternative("CleanPullbackMode", "Classic pullbacks", "", "CLASSIC")
    strategy.parameters:addDouble("CleanPullbackMinScore", "Upgraded Pullback Minimum Quality", "Dedicated 0-100 touch/reclaim/candle/location score; does not replace risk sizing quality", 60, 0, 100)
    strategy.parameters:addDouble("CleanPullbackMinSlopeATR", "Early Trend Minimum EMA9/20 Slope, ATR", "Before EMA50 alignment, both EMA9 and EMA20 slopes must exceed this value in the trade direction. Zero still requires strictly positive directional slopes.", 0.0, 0.0, 1.0)
    strategy.parameters:addDouble("CleanPullbackMaxAdverseATR", "Invalidate Pending EMA Touch, ATR", "A completed close beyond the touched EMA by this adverse ATR distance invalidates that pending touch", 0.75, 0.0, 3.0)
    strategy.parameters:addBoolean("CleanRequireFullEMAStack", "Require Full EMA 9/20/50 Stack", "Hard direction rule for CLASSIC pullbacks, breakout and continuation setups. UPGRADED pullbacks can qualify earlier through EMA9/20, slope, ADX and DMI confirmation.", true)
    strategy.parameters:addDouble("CleanMinEntryScore", "Clean Minimum Entry Score", "", 55, 0, 100)
    strategy.parameters:addDouble("CleanMinDMIRatio", "Clean Trend DMI Ratio", "", 1.20, 1.0, 5.0)
    strategy.parameters:addDouble("CleanImpulseStateATR", "Strong Impulse State Override, ATR", "", 0.75, 0.1, 5)
    strategy.parameters:addDouble("CleanTransitionADX", "Transition Continuation ADX", "", 20, 0, 100)
    strategy.parameters:addDouble("CleanTransitionDMIRatio", "Transition DMI Ratio", "", 1.50, 1.0, 5.0)
    strategy.parameters:addDouble("CleanTransitionMomentumATR", "Transition Momentum, ATR", "", 0.50, 0, 5)
    strategy.parameters:addDouble("CleanRangeMaxADX", "Range Maximum ADX", "", 18, 0, 100)
    strategy.parameters:addDouble("CleanRangeMaxMACompressionATR", "Range MA Compression, ATR", "", 0.45, 0, 3)
    strategy.parameters:addDouble("CleanRangeMaxMomentumATR", "Range Maximum Momentum, ATR", "", 0.45, 0, 3)
    strategy.parameters:addDouble("CleanTriggerBodyATR", "Minimum Trigger Body, ATR", "", 0.08, 0, 2)
    strategy.parameters:addDouble("CleanTriggerCloseLoc", "Directional Close Location", "", 0.60, 0.5, 1)
    strategy.parameters:addDouble("CleanContinuationMomentumATR", "Continuation Momentum, ATR", "Minimum directional momentum for a confirmed EMA re-base continuation", 0.00, 0, 5)
    strategy.parameters:addDouble("CleanContinuationEMARejectATR", "Continuation EMA9 Reject Tolerance, ATR", "", 0.20, 0, 2)
    strategy.parameters:addDouble("CleanContinuationMaxFastGapATR", "Continuation Max EMA9 Gap, ATR", "Good-location continuation must remain close to EMA9; direct chase entries are rejected", 0.75, 0.1, 5)
    strategy.parameters:addDouble("CleanContinuationMaxMomentumATR", "Continuation Maximum Momentum, ATR", "Allow strong confirmed continuation while still requiring recent EMA re-base, candle confirmation and limited EMA9 distance", 3.20, 0.2, 5)
    strategy.parameters:addInteger("CleanContinuationRebaseLookback", "Continuation Re-base Lookback, bars", "Require a recent EMA9/EMA20 retest/consolidation before continuation; prevents buying/selling a mature impulse", 4, 1, 20)
    strategy.parameters:addDouble("CleanContinuationRebaseTouchATR", "Continuation Re-base EMA Touch, ATR", "Tolerance for a recent EMA9/EMA20 retest used by good-location continuation", 0.35, 0, 2)
    strategy.parameters:addBoolean("CleanUseVWAPQuality", "Use VWAP Quality Layer", "VWAP is a quality/extension input for the clean engine; it is not a universal hard trend filter", true)
    strategy.parameters:addBoolean("BlockEntriesFarFromVWAP", "Block Entries Too Far From VWAP", "Hard veto for ALL entry engines when absolute close-to-VWAP distance exceeds the configured ATR limit; independent of setup-specific VWAP quality rules", true)
    strategy.parameters:addDouble("MaxEntryVWAPDistanceATR", "Maximum Entry Distance From VWAP, ATR", "When the hard VWAP-distance block is ON, reject entries farther than this absolute ATR-normalized distance from VWAP (GER30 M1 profile: 6 ATR)", 6.0, 0.5, 100.0)
    strategy.parameters:addDouble("CleanVWAPAlignedBonus", "VWAP Aligned Score Bonus", "Adds score when price is on the candidate side of VWAP", 5.0, 0, 20)
    strategy.parameters:addDouble("CleanVWAPOpposedPenalty", "VWAP Mild Opposition Score Penalty", "Subtracts a small score when price is mildly on the wrong side of VWAP; pullbacks remain allowed", 3.0, 0, 20)
    strategy.parameters:addDouble("CleanContinuationMaxVWAPStretchATR", "Continuation Maximum VWAP Stretch, ATR", "Blocks only continuation/chase entries beyond this directional VWAP stretch; pullbacks remain allowed", 2.75, 0.5, 20)
    strategy.parameters:addDouble("CleanBreakoutMaxVWAPStretchATR", "Breakout Maximum VWAP Stretch, ATR", "Fresh breakouts get more room than continuations; only extreme chase entries are blocked", 4.00, 0.5, 20)
    strategy.parameters:addDouble("CleanPullbackVWAPPenaltyATR", "Pullback VWAP Penalty Starts, ATR", "Directional pullbacks beyond this VWAP stretch remain possible but lose score; keep below the maximum stretch", 3.0, 0.5, 20)
    strategy.parameters:addDouble("CleanPullbackMaxVWAPStretchATR", "Pullback Maximum VWAP Stretch, ATR", "Directional EMA pullbacks beyond this mature-trend stretch are blocked", 4.5, 0.5, 20)
    strategy.parameters:addDouble("CleanPullbackVWAPPenaltyScore", "Pullback Extended VWAP Score Penalty", "Score removed when directional VWAP stretch is between the penalty and hard-cap levels", 8.0, 0, 30)
    strategy.parameters:addDouble("CleanPullbackStateMaxCounterMomentumATR", "Pullback State Max Counter Momentum, ATR", "Keeps TREND_UP_PULLBACK / TREND_DOWN_PULLBACK while the full EMA stack, ADX and DMI remain aligned and counter-momentum is no larger than this", 0.75, 0, 5)
    strategy.parameters:addDouble("CleanPullbackTouchATR", "EMA9/20 Touch Tolerance, ATR", "", 0.25, 0, 2)
    strategy.parameters:addDouble("CleanPullbackReclaimATR", "EMA Reclaim, ATR", "", 0.10, 0, 1)
    strategy.parameters:addInteger("CleanPullbackRetestLookbackBars", "EMA Pullback Retest Lookback, Bars", "The confirming candle may reclaim an EMA retested now or within the previous bars; all other pullback filters still apply", 2, 0, 5)
    strategy.parameters:addDouble("CleanPullbackMinDMIRatio", "Pullback Minimum DMI Ratio", "", 0.90, 0.5, 5)
    strategy.parameters:addDouble("CleanPullbackMaxFastGapATR", "Pullback Max EMA9 Gap, ATR", "", 1.0, 0.1, 5)
    strategy.parameters:addInteger("CleanBreakoutLookback", "Breakout Lookback Bars", "Fresh breakout structure lookback", 12, 3, 100)
    strategy.parameters:addInteger("CleanRangeLookback", "Range Lookback Bars", "Independent RANGE boundary lookback measured in bars of the selected Trading Timeframe", 30, 20, 50)
    strategy.parameters:addDouble("CleanBreakoutBufferATR", "Breakout Buffer, ATR", "", 0.03, 0, 1)
    strategy.parameters:addDouble("CleanBreakoutMomentumATR", "Breakout Momentum, ATR", "", 0.70, 0, 5)
    strategy.parameters:addDouble("CleanBreakoutMinADX", "Breakout Minimum ADX", "", 15, 0, 100)
    strategy.parameters:addDouble("CleanBreakoutMinDMIRatio", "Breakout Minimum DMI Ratio", "", 1.20, 1.0, 5)
    strategy.parameters:addDouble("CleanBreakoutBodyATR", "Breakout Minimum Body, ATR", "", 0.20, 0, 5)
    strategy.parameters:addDouble("CleanBreakoutCloseLoc", "Breakout Close Location", "", 0.68, 0.5, 1)
    strategy.parameters:addDouble("CleanBreakoutMaxFastGapATR", "Breakout Max EMA9 Gap, ATR", "", 0.75, 0.1, 6)
    strategy.parameters:addBoolean("CleanAllowRange", "Allow Clean Range Trades", "Disabled in the GER30 M1 trend/breakout profile", false)
    strategy.parameters:addDouble("CleanRangeEdgeFraction", "Clean Range Edge Fraction", "Outer fraction eligible for mean-reversion entries", 0.30, 0.1, 0.49)
    strategy.parameters:addDouble("CleanRangeLongMaxRSI", "Clean Range Long RSI Max", "", 45, 10, 60)
    strategy.parameters:addDouble("CleanRangeShortMinRSI", "Clean Range Short RSI Min", "", 55, 40, 90)
    strategy.parameters:addDouble("CleanRangeMinScore", "Range Minimum Entry Score", "Dedicated 0-100 range-quality score", 55, 0, 100)
    strategy.parameters:addBoolean("CleanRangeUseVWAPMeanReversion", "Use Range VWAP Mean-Reversion Quality", "Reward BUY below VWAP and SELL above VWAP; does not require a directional trend stack", true)
    strategy.parameters:addBoolean("CleanRangeRequire2RRoom", "Require Full Target Room in Range", "Block entries when the established range boundary cannot accommodate the actual submitted target distance", true)
    strategy.parameters:addBoolean("UseRangeStopWidthGate", "Use Range Stop/Width Gate", "For CHOPPY_RANGE entries, reject a stop that is too large relative to the established CleanRangeLookback range width", true)
    strategy.parameters:addDouble("MaxRangeStopFraction", "Maximum Range Stop / Width", "Maximum required stop as a fraction of the established range width; 0.50 means a 40-point range permits at most a 20-point stop", 0.50, 0.10, 1.00)
    strategy.parameters:addDouble("CleanRangeBreakoutCandleATR", "Range Breakout-Danger Candle, ATR", "Block mean reversion when the signal bar range is expansion-sized", 1.00, 0.3, 5)
    strategy.parameters:addDouble("CleanRangeDangerDMIRatio", "Range Adverse DMI Danger Ratio", "Block when DMI and momentum strongly expand against the proposed fade", 1.80, 1.0, 10)
    strategy.parameters:addDouble("CleanRangeDangerMomentumATR", "Range Adverse Momentum Danger, ATR", "", 0.30, 0, 3)
    strategy.parameters:addDouble("CleanRangeDangerADX", "Range ADX Warning Level", "Near range-state ceiling; requires adverse momentum to block", 16.0, 0, 100)

    strategy.parameters:addGroup("Adaptive Stops / Targets (GER30 points)")
    strategy.parameters:addDouble("ATRStopTrend", "Trend Base Stop ATR", "Base ATR multiple before optional upper-volatility widening and safety floors", 2.0, 0.5, 10)
    strategy.parameters:addDouble("ATRStopRange", "Range Base Stop ATR", "Base ATR multiple before optional upper-volatility widening and safety floors", 2.0, 0.5, 10)
    strategy.parameters:addDouble("ATRStopBreakout", "Breakout Base Stop ATR", "Base ATR multiple before optional upper-volatility widening and safety floors", 2.0, 0.5, 10)
    strategy.parameters:addDouble("ATRStopReversal", "Reversal Base Stop ATR", "Base ATR multiple before optional upper-volatility widening and safety floors", 2.0, 0.5, 10)
    strategy.parameters:addDouble("MinStopATR", "Minimum Stop Distance, ATR", "Quiet bars still need real room", 2.0, 0, 10)
    strategy.parameters:addDouble("MinStopPips", "Minimum Stop Distance, points", "GER30 index points (FXCM pip≈1 pt). Sample-based floor", 15.0, 0, 500)
    strategy.parameters:addDouble("StopSpreadMultiple", "Min Stop as Multiple of Spread", "Spread-aware safety floor applied again at live order preflight", 5.0, 0, 50)
    strategy.parameters:addInteger("VolatilityLookback", "Volatility ATR Percentile Lookback", "Dedicated ATR-percentile window for stop widening and volatility risk scaling; independent of StatsPeriod", 50, 20, 200)
    strategy.parameters:addBoolean("UseVolatilityStopWidening", "Use Volatility Stop Widening", "Widen the ATR stop smoothly in the upper ATR-percentile regime", true)
    strategy.parameters:addDouble("VolWidenStartPct", "Volatility Widening Starts At Percentile", "0.75 means widening starts above the 75th ATR percentile", 0.75, 0.0, 0.99)
    strategy.parameters:addDouble("VolWidenFullPct", "Volatility Widening Full At Percentile", "Percentile where VolWidenMax is fully applied", 1.00, 0.01, 1.00)
    strategy.parameters:addDouble("VolWidenMax", "Maximum Volatility Stop Widening", "0.25 means the ATR component can widen by at most 25%", 0.25, 0.0, 1.00)
    strategy.parameters:addString("FixedStopVolatilityPolicy", "Fixed Stop Volatility Policy", "When Set Stop Orders=Yes: FIXED_WITH_FLOORS keeps the fixed stop plus safety floors; FIXED_WITH_VOLATILITY also requires the widened ATR stop; ADAPTIVE ignores the fixed value and uses the adaptive stop geometry", "FIXED_WITH_FLOORS")
    strategy.parameters:addStringAlternative("FixedStopVolatilityPolicy", "Fixed stop + safety floors", "", "FIXED_WITH_FLOORS")
    strategy.parameters:addStringAlternative("FixedStopVolatilityPolicy", "Fixed stop + widened ATR + floors", "", "FIXED_WITH_VOLATILITY")
    strategy.parameters:addStringAlternative("FixedStopVolatilityPolicy", "Adaptive geometry even when SetStop is enabled", "", "ADAPTIVE")
    strategy.parameters:addDouble("MaxEntryStopPips", "Maximum Acceptable Entry Stop, points", "Hard strategy-fit veto after affordability is evaluated. Zero disables. The required stop is never truncated to this value", 40.0, 0.0, 1000.0)
    strategy.parameters:addDouble("RRTrend", "Trend Reward/Risk", "Standardized: target = 2.0R", 2.0, 0.5, 10)
    strategy.parameters:addDouble("RRRange", "Range Reward/Risk", "Standardized: target = 2.0R", 2.0, 0.5, 10)
    strategy.parameters:addDouble("RRBreakout", "Breakout Reward/Risk", "Standardized: target = 2.0R", 2.0, 0.5, 10)
    strategy.parameters:addDouble("RRReversal", "Reversal Reward/Risk", "Standardized: target = 2.0R", 2.0, 0.5, 10)
    strategy.parameters:addDouble("BreakEvenR", "Break-even Thesis Trigger, R", "", 0.9, 0.2, 5)
    strategy.parameters:addDouble("TrailATR", "ATR Thesis Trail", "", 1.5, 0.3, 10)
    strategy.parameters:addDouble("MinTrailPips", "Minimum Trail Distance, points", "Never trail inside ~1 median ATR", 8.0, 0, 200)
    strategy.parameters:addInteger("MaxBarsInTrade", "Maximum Bars in Trade", "Measured in bars of the selected Trading Timeframe (e.g. 25 on m5 = about 125 minutes)", 25, 1, 5000)

    strategy.parameters:addGroup("Unified Volatility Risk Curve")
    strategy.parameters:addDouble("VolRiskP25", "Risk Multiplier at ATR Percentile 25%", "Smooth lookup knot; values between knots are linearly interpolated", 0.85, 0.10, 1.00)
    strategy.parameters:addDouble("VolRiskP50", "Risk Multiplier at ATR Percentile 50%", "Normal-volatility anchor", 1.00, 0.10, 1.00)
    strategy.parameters:addDouble("VolRiskP60", "Risk Multiplier at ATR Percentile 60%", "", 0.95, 0.10, 1.00)
    strategy.parameters:addDouble("VolRiskP70", "Risk Multiplier at ATR Percentile 70%", "", 0.90, 0.10, 1.00)
    strategy.parameters:addDouble("VolRiskP80", "Risk Multiplier at ATR Percentile 80%", "", 0.82, 0.10, 1.00)
    strategy.parameters:addDouble("VolRiskP90", "Risk Multiplier at ATR Percentile 90%", "", 0.75, 0.10, 1.00)
    strategy.parameters:addDouble("VolRiskP100", "Risk Multiplier at ATR Percentile 100%", "Upper-volatility risk floor for the unified curve", 0.70, 0.10, 1.00)

    strategy.parameters:addGroup("Smart Money Management")
    strategy.parameters:addBoolean("UseSmartMoneyManagement", "Use Smart Money Management", "AdaptiveRisk uses quality/volatility/loss-streak/drawdown scaling. Guarded FixedLots keeps these as diagnostics but tests the requested lot size against the HARD RiskPct/open-risk/daily-room budget.", true)
    strategy.parameters:addBoolean("ScaleRiskByQuality", "Scale Risk by Evidence Quality", "Higher evidence vs required increases size toward ScaleMax; weaker setups reduce toward ScaleMin", true)
    strategy.parameters:addDouble("RiskScaleMin", "Minimum Risk Scale", "Floor multiplier on RiskPct for weak-but-still-valid setups", 0.50, 0.10, 1.0)
    strategy.parameters:addDouble("RiskScaleMax", "Maximum Risk Scale", "Ceiling multiplier on RiskPct for high-quality setups (1.0 = never risk more than RiskPct)", 1.00, 0.50, 1.0)
    strategy.parameters:addBoolean("ScaleRiskByLossStreak", "Scale Risk by Loss Streak", "Each consecutive loss multiplies risk by LossStreakFactor until the hard consecutive-loss cap", true)
    strategy.parameters:addDouble("LossStreakFactor", "Loss Streak Risk Factor", "Per consecutive loss multiplier (e.g. 0.70 => 70% risk after 1 loss, 49% after 2)", 0.70, 0.20, 1.0)
    strategy.parameters:addBoolean("ScaleRiskByDrawdown", "Scale Risk by Daily Drawdown", "Linearly reduce risk as session equity approaches MaxDailyLossPct", true)
    strategy.parameters:addDouble("DrawdownScaleStartPct", "Drawdown Scale Start, % of Daily Cap", "Begin reducing risk when drawdown reaches this fraction of MaxDailyLossPct (0.5 = halfway to the daily cap)", 0.50, 0.10, 1.0)

    strategy.parameters:addGroup("Smart Trade Management")
    strategy.parameters:addBoolean("ExitOnRegimeFlip", "Exit on Opposing Trend Regime", "When enabled, close a long after a confirmed bearish base regime or a short after a confirmed bullish base regime. Default OFF for this profile.", false)
    strategy.parameters:addBoolean("ExitOnThesisInvalidation", "Exit on EMA/VWAP Thesis Failure", "When enabled, generic trend positions close after a completed candle closes beyond both EMA50 and VWAP against the position. Setup-specific range/breakout/reversal invalidation remains separate.", false)
    strategy.parameters:addBoolean("UseSmartTradeManagement", "Use Smart Trade Management", "Profit-lock, trail tighten, optional CHOCH and giveback exits on top of the existing BE/ATR ratchet", true)
    strategy.parameters:addDouble("LockProfitR", "Lock Profit at R", "Once unrealized profit reaches this R multiple, thesis stop ratchets to entry + LockProfitFraction * initial risk (longs) / symmetric for shorts", 1.0, 0.5, 10)
    strategy.parameters:addDouble("LockProfitFraction", "Locked Profit Fraction of R", "Fraction of initial risk locked once LockProfitR is reached (0.25 locks a quarter-R of profit)", 0.25, 0.0, 2.0)
    strategy.parameters:addDouble("TrailTightenAfterR", "Tighten Trail After R", "After this unrealized R, use TrailATR * TrailTightenFactor for a tighter ratchet", 1.5, 0.5, 10)
    strategy.parameters:addDouble("TrailTightenFactor", "Trail Tighten Factor", "Multiplier applied to TrailATR after TrailTightenAfterR (0.70 = 30% tighter trail)", 0.70, 0.25, 1.0)
    strategy.parameters:addBoolean("ExitOnAdverseCHOCH", "Exit on Adverse CHOCH", "Close the trade when a confirmed change-of-character opposes the open side", false)
    strategy.parameters:addBoolean("UseGivebackExit", "Use Giveback Exit", "If MFE reached GivebackArmR and price retraces to GivebackFloorR or worse, exit to protect remaining open risk", true)
    strategy.parameters:addDouble("GivebackArmR", "Giveback Arm R", "Minimum peak favorable excursion (R) before giveback protection arms", 1.2, 0.5, 10)
    strategy.parameters:addDouble("GivebackFloorR", "Giveback Floor R", "Exit when current open R falls to this level or below after the giveback arm has triggered", 0.40, -1.0, 5)

    strategy.parameters:addGroup("Volume")
    strategy.parameters:addBoolean("UseVolumeFilter", "Use Tick-Volume Confirmation", "When enabled, only *available but weak* tick volume blocks entry. Missing volume (indices/CFDs) is skipped, not blocked", false)
    strategy.parameters:addInteger("VolumeLookback", "Volume Average Period", "", 20, 5, 300)
    strategy.parameters:addDouble("VolumeFactor", "Required Volume / Average", "", 1.0, 0, 5)

    -- APS-style trading controls, matching the proven working strategy.
    strategy.parameters:addGroup("Trading Parameters")
    strategy.parameters:addBoolean("AllowTrade", "Allow strategy to trade", "", true)
    strategy.parameters:setFlag("AllowTrade", core.FLAG_ALLOW_TRADE)

    strategy.parameters:addString("AccountType", "Account Type", "", "Automatic")
    strategy.parameters:addStringAlternative("AccountType", "FIFO", "", "FIFO")
    strategy.parameters:addStringAlternative("AccountType", "non FIFO", "", "NON")
    strategy.parameters:addStringAlternative("AccountType", "Automatic", "", "Automatic")

    strategy.parameters:addString("ALLOWEDSIDE", "Allowed side", "Allowed side for trading or signaling, can be Sell, Buy or Both", "Both")
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Both", "", "Both")
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Buy", "", "Buy")
    strategy.parameters:addStringAlternative("ALLOWEDSIDE", "Sell", "", "Sell")

    strategy.parameters:addBoolean("AllowMultiple", "Allow Multiple", "", false)
    strategy.parameters:addBoolean("OneTradePerDirection", "One Trade Per Direction", "When enabled, blocks another long while a long is open and likewise for shorts", true)
    strategy.parameters:addString("Account", "Account to trade on", "", "")
    strategy.parameters:setFlag("Account", core.FLAG_ACCOUNT)
    strategy.parameters:addInteger("Amount", "Trade Amount in Lots", "", 1, 1, 1000000)
    strategy.parameters:addBoolean("SetLimit", "Set Limit Orders", "", false)
    strategy.parameters:addInteger("Limit", "Limit Order in pips", "", 30, 1, 10000)
    strategy.parameters:addBoolean("SetStop", "Set Stop Orders", "", false)
    strategy.parameters:addInteger("Stop", "Stop Order in pips", "", 30, 1, 10000)
    strategy.parameters:addBoolean("TrailingStop", "Move Broker Stop to Break-Even / ATR Trail", "Edits the real resting stop: initial stop, then break-even at BreakEvenR, then a monotonic TrailATR ratchet", true)

    strategy.parameters:addGroup("Advanced Execution / Risk")
    strategy.parameters:addString("SizingMode", "Position Sizing Mode", "Adaptive Risk uses equity and final stop/costs. Fixed Lots is capped by the monetary guard unless explicitly disabled", "AdaptiveRisk")
    strategy.parameters:addStringAlternative("SizingMode", "Fixed Lots (APS)", "", "FixedLots")
    strategy.parameters:addStringAlternative("SizingMode", "Adaptive Risk", "", "AdaptiveRisk")
    strategy.parameters:addString("CustomID", "Unique Instance Identifier", "Change this ID if it is already used by another strategy instance on this account and instrument", "ARS9222_GER30_M1_M15_TREND_A7C41F")
    strategy.parameters:addInteger("MaxPositions", "Max Simultaneous Positions (when Allow Multiple = Yes)", "", 1, 1, 20)
    strategy.parameters:addInteger("MinBarsBetweenTrades", "Minimum Bars Between Trades", "Profile-independent cooldown starts only after broker-confirmed trade close", 10, 0, 1000)
    strategy.parameters:addInteger("SetupResetBars", "Setup Reuse Timeout, bars", "A setup also resets immediately when its structural swing anchor changes", 30, 1, 5000)
    strategy.parameters:addInteger("PendingOpenTimeoutBars", "Pending Open Confirmation Timeout, bars", "Raises a fail-closed safety lock if an open request remains unresolved for this many closed bars; inspect broker state or restart after verification rather than risk a duplicate late fill", 20, 1, 500)
    strategy.parameters:addInteger("PendingCloseTimeoutBars", "Pending Close Confirmation Timeout, bars", "Re-enables a synthetic exit when a close request remains unresolved and the trade is still open", 5, 1, 100)
    strategy.parameters:addDouble("MaxSpreadPips", "Maximum Spread, points", "GER30 M1 maximum allowed spread before an entry is blocked", 5.0, 0, 100)
    strategy.parameters:addDouble("RiskPct", "Maximum Planned Risk Per Trade, % Equity", "Applies to AdaptiveRisk and guarded FixedLots; excludes unmodeled execution loss", 0.5, 0.01, 2)
    strategy.parameters:addString("PipValueMode", "Pip Value Source", "AUTO_BROKER reads FXCM Offers.PipCost for one broker base-size lot in account currency. MANUAL uses the override below. AUTO_BROKER fails closed if broker pip cost is unavailable.", "AUTO_BROKER")
    strategy.parameters:addStringAlternative("PipValueMode", "Automatic - FXCM broker PipCost (recommended)", "", "AUTO_BROKER")
    strategy.parameters:addStringAlternative("PipValueMode", "Manual override", "", "MANUAL")
    strategy.parameters:addDouble("PipValuePerBaseUnit", "Manual Pip Value Per Base-Size Lot", "Used only when Pip Value Source = Manual override. Account-currency value of one broker pip for exactly one broker base-size lot.", 0.0, 0.0, 1000000)
    strategy.parameters:addInteger("MaxUnits", "Maximum Units Per Trade", "", 100000, 1, 100000000)
    strategy.parameters:addInteger("MaxTotalUnits", "Maximum Total Strategy Exposure, units", "Counts all open positions owned by this strategy on this instrument", 100000, 1, 100000000)
    strategy.parameters:addDouble("MinLots", "Minimum Lots (Adaptive Risk mode)", "", 1, 1, 1000000)
    strategy.parameters:addDouble("MaxLots", "Maximum Lots (Adaptive Risk mode)", "", 100, 1, 1000000)
    strategy.parameters:addBoolean("FixedLotRiskGuard", "Apply Monetary Risk Guard to Fixed Lots", "ON: requested FixedLots must fit the HARD RiskPct/open-risk/daily-room budget; Smart Money soft scaling cannot reduce an otherwise affordable fixed lot to zero. Uses the selected broker/manual pip-value source. OFF: explicit manual sizing without monetary sizing caps", true)
    strategy.parameters:addDouble("MaxOpenRiskPct", "Maximum Strategy Open Stop Risk, % Equity", "Caps this instance/instrument's estimated entry-to-stop loss; profitable stops never finance extra risk", 2.0, 0.1, 10)
    strategy.parameters:addDouble("RiskSlippagePips", "Execution Risk Reserve, pips", "Estimated adverse execution allowance per trade; not a guaranteed slippage limit", 1.0, 0, 100)
    strategy.parameters:addDouble("RoundTripCommissionPerLot", "Round-Trip Commission Per Base Lot", "Account-currency estimate; configure for your broker. Zero means no commission reserve", 0.0, 0, 10000)
    strategy.parameters:addDouble("MinNetRewardRisk", "Minimum Planned Reward/Risk After Costs", "Guarded sizing only; target and stop include the configured execution/commission reserve", 1.0, 0, 5)
    strategy.parameters:addDouble("MaxDailyLossPct", "Maximum Daily Equity Loss %", "GER30 M1 can cluster losses - keep a hard daily brake", 2.0, 0.1, 50)
    strategy.parameters:addInteger("MaxConsecutiveLosses", "Maximum Consecutive Losses", "", 3, 1, 50)
    strategy.parameters:addBoolean("BreakEvenResetsLossStreak", "Break-Even Resets Loss Streak", "ON: a broker-confirmed break-even trade interrupts the consecutive-loss sequence. OFF: break-even preserves the existing loss streak.", true)

    strategy.parameters:addGroup("Session")
    strategy.parameters:addInteger("ToTime", "Session Time Zone", "", 2)
    strategy.parameters:addIntegerAlternative("ToTime", "EST", "", 1)
    strategy.parameters:addIntegerAlternative("ToTime", "UTC", "", 2)
    strategy.parameters:addIntegerAlternative("ToTime", "Local", "", 3)
    strategy.parameters:addIntegerAlternative("ToTime", "Server", "", 4)
    strategy.parameters:addIntegerAlternative("ToTime", "Financial", "", 5)
    strategy.parameters:addIntegerAlternative("ToTime", "Display", "", 6)
    strategy.parameters:addString("StartTime", "Start Time", "", "07:00:00")
    strategy.parameters:addString("StopTime", "Stop Time", "", "16:00:00")
    strategy.parameters:addBoolean("UseMandatoryClose", "Use Mandatory Closing Time", "Close all positions owned by this strategy once per day at the configured session-timezone clock", false)
    strategy.parameters:addString("MandatoryCloseTime", "Mandatory Closing Time", "Uses the selected Session Time Zone; execution occurs on the first closed bar reaching or crossing this time", "23:59:00")
    strategy.parameters:addBoolean("UseCETLunchBreak", "Use CET/CEST Lunch Break", "Block NEW entries during the configured Central-European lunch window; open trades are still managed", false)
    strategy.parameters:addString("CETLunchStart", "CET Lunch Break Start", "Central-European clock; automatically follows CET/CEST DST", "12:00:00")
    strategy.parameters:addString("CETLunchEnd", "CET Lunch Break End", "Central-European clock; automatically follows CET/CEST DST", "14:00:00")

    strategy.parameters:addGroup("Global Trading Sessions (UTC)")
    strategy.parameters:addBoolean("UseGlobalSessionFilter", "Use Global Session Entry Filter", "GER30: ON - focus London/NY; Asia ATR often too quiet for M1 edges", true)
    strategy.parameters:addString("SydneyOpenUTC", "Sydney/Pacific Open UTC", "Configurable because published session conventions and DST treatment can vary", "21:00:00")
    strategy.parameters:addString("SydneyCloseUTC", "Sydney/Pacific Close UTC", "Cross-midnight windows are supported", "06:00:00")
    strategy.parameters:addString("TokyoOpenUTC", "Tokyo/Asia Open UTC", "", "23:00:00")
    strategy.parameters:addString("TokyoCloseUTC", "Tokyo/Asia Close UTC", "", "08:00:00")
    strategy.parameters:addString("LondonOpenUTC", "London/Europe Open UTC", "", "07:00:00")
    strategy.parameters:addString("LondonCloseUTC", "London/Europe Close UTC", "", "16:00:00")
    strategy.parameters:addString("NewYorkOpenUTC", "New York/America Open UTC", "", "12:00:00")
    strategy.parameters:addString("NewYorkCloseUTC", "New York/America Close UTC", "", "21:00:00")
    strategy.parameters:addBoolean("TradeSydney", "Allow Sydney/Pacific Entries", "GER30: off - ATR usually too low", false)
    strategy.parameters:addBoolean("TradeSydneyTokyoOverlap", "Allow Sydney-Tokyo Overlap Entries", "", false)
    strategy.parameters:addBoolean("TradeTokyo", "Allow Tokyo/Asia Entries", "GER30: off - prefer London open onward", false)
    strategy.parameters:addBoolean("TradeTokyoLondonOverlap", "Allow Tokyo-London Overlap Entries", "Early London ramp", true)
    strategy.parameters:addBoolean("TradeLondon", "Allow London/Europe Entries", "Core GER30 session", true)
    strategy.parameters:addBoolean("TradeLondonNewYorkOverlap", "Allow London-New York Overlap Entries", "Peak edge window", true)
    strategy.parameters:addBoolean("TradeNewYork", "Allow New York/America Entries", "Still active until EU close", true)
    strategy.parameters:addBoolean("TradeOffHours", "Allow Off-Hours Entries", "GER30: off", false)


    strategy.parameters:addGroup("Key Levels (Asian / Prior Day / London OR)")
    strategy.parameters:addBoolean("UseKeyLevels", "Use Key Levels Engine", "Track Asian H/L, previous UTC-day H/L, and London opening range for breakout and false-breakout geometry", true)
    strategy.parameters:addBoolean("UseKeyLevelBreakout", "Allow Key-Level Breakout Entries", "Close beyond Asian/PD/OR high or low with momentum qualifies as breakout geometry", true)
    strategy.parameters:addBoolean("UseKeyLevelFalseBreakout", "Allow Key-Level False-Breakout Entries", "Sweep beyond a key level then close back inside (with optional rejection) for fade/reversal/range paths", true)
    strategy.parameters:addString("AsianRangeStartUTC", "Asian Range Start UTC", "UTC clock when Asian high/low accumulation begins (supports cross-midnight)", "00:00:00")
    strategy.parameters:addString("AsianRangeEndUTC", "Asian Range End UTC", "UTC clock when Asian range freezes for London use; default ends at London open", "07:00:00")
    strategy.parameters:addInteger("LondonORMinutes", "London Opening Range Minutes", "First N minutes after London open UTC form the opening range; breakouts use the completed range only", 30, 5, 120)
    strategy.parameters:addDouble("KeyLevelBufferATR", "Key Level Touch Buffer, ATR", "Soft near-level distance used in diagnostics/regime soft boost", 0.05, 0, 0.5)
    strategy.parameters:addDouble("KeyLevelFalseBreakPierceATR", "False-Break Min Pierce, ATR", "Wick must exceed the level by this ATR multiple before a false-breakout counts", 0.10, 0.01, 1.0)
    strategy.parameters:addBoolean("KeyLevelFalseBreakRequireRejection", "False-Break Require Rejection Wick", "Require bullish/bearish rejection candle shape on the reclaim bar", true)
    strategy.parameters:addDouble("KeyLevelFalseBreakRSIMax", "False-Break Long Max RSI", "Long false-breakout RSI must be at or below this", 55, 20, 70)
    strategy.parameters:addDouble("KeyLevelFalseBreakRSIMin", "False-Break Short Min RSI", "Short false-breakout RSI must be at or above this", 45, 30, 80)

    strategy.parameters:addGroup("Scheduled News Filter (UTC)")
    strategy.parameters:addBoolean("UseNewsFilter", "Use Local UTC News Entry Filter", "Blocks new entries around scheduled events; open trades, exits, and broker-stop management continue", false)
    strategy.parameters:addString("NewsEventScheduleUTC", "UTC News Events", "Semicolon-separated exact UTC events: YYYY-MM-DD HH:MM|Label; YYYY-MM-DD HH:MM|Label. When enabled, an empty or malformed schedule blocks entries", "")
    strategy.parameters:addInteger("NewsBlockMinutesBefore", "Block Minutes Before News", "Entry blackout begins this many minutes before every scheduled event", 30, 0, 1440)
    strategy.parameters:addInteger("NewsBlockMinutesAfter", "Block Minutes After News", "Entry blackout ends this many minutes after every scheduled event", 30, 0, 1440)
    strategy.parameters:addBoolean("NewsRequireFutureEvent", "Fail Closed After Last Scheduled Event", "Prevents an expired schedule from silently allowing unfiltered entries; add future events or explicitly disable this check", true)

    strategy.parameters:addGroup("Smart AI Meta-Filter")
    strategy.parameters:addString("MLMode", "Smart AI Mode", "OFF disables; OBSERVE learns without blocking; FILTER may veto rule-qualified entries only after warm-up. Never opens trades or raises size", "OBSERVE")
    strategy.parameters:addStringAlternative("MLMode", "Off", "", "OFF")
    strategy.parameters:addStringAlternative("MLMode", "Observe and Learn (recommended)", "", "OBSERVE")
    strategy.parameters:addStringAlternative("MLMode", "Filter after Warm-up", "", "FILTER")
    strategy.parameters:addInteger("MLMinSamples", "Minimum Completed Trades (Warm-up)", "FILTER passes normal rule-qualified trades until this many non-break-even labels have trained the model", 40, 20, 10000)
    strategy.parameters:addDouble("MLProbabilityThreshold", "Base Minimum Win Probability", "FILTER mode base threshold; adaptive adjustments may raise it in adverse context", 0.55, 0.50, 0.95)
    strategy.parameters:addBoolean("MLAdaptiveThreshold", "Adaptive Threshold", "Raise the bar on loss streak, high vol, opposing state, or opposing CHOCH; slightly ease when state+structure align", true)
    strategy.parameters:addInteger("MLRecentWindow", "Recent Outcome Window", "Rolling trades used for the fast empirical prior in the Smart AI ensemble", 30, 5, 200)
    strategy.parameters:addBoolean("MLWeightByR", "Weight Learning by R-Multiple", "Larger absolute R outcomes update logistic weights more (bounded 0.5x-2.5x)", true)
    strategy.parameters:addDouble("MLLearningRate", "Online Learning Rate", "Bounded stochastic-gradient step applied once per completely closed trade", 0.05, 0.001, 0.50)
    strategy.parameters:addDouble("MLL2", "L2 Regularization", "Weight-decay strength; bias is not penalized", 0.001, 0.0, 0.10)
    strategy.parameters:addDouble("MLMaxAbsWeight", "Maximum Absolute Weight", "Hard stability bound for every learned coefficient", 3.0, 0.25, 20.0)
    strategy.parameters:addBoolean("MLBalanceClasses", "Balance Win/Loss Classes", "Bounded inverse-frequency weighting reduces majority-class collapse", true)
    strategy.parameters:addBoolean("MLShareAcrossAccounts", "Share Smart AI Model Across Accounts", "Uses one local model for demo/live on this FXCM installation. Use the same group and entry settings; do not run both accounts at once.", true)
    strategy.parameters:addString("MLModelGroup", "Smart AI Shared Model Group", "Must match between demo and live instances; a different group uses a separate local model.", "GER30_NIDEX_M1_SHARED")
    strategy.parameters:addBoolean("MLPersistModel", "Persist Smart AI Model Locally", "Required for demo/live model sharing; learned weights are stored on this FXCM installation.", true)
    strategy.parameters:addBoolean("MLResetModel", "RESET Persisted Model on Prepare", "Set Yes for one launch only, then return to No; erases learned weights for this CustomID/instrument/timeframe", false)

    strategy.parameters:addGroup("CLEAN Entry Quality")
    strategy.parameters:addString("EntryQualityMode", "Entry Quality Mode", "OBSERVE logs checks only; ENFORCE blocks failed quality checks; OFF disables. Start with OBSERVE and review the CSV before enforcing", "OBSERVE")
    strategy.parameters:addStringAlternative("EntryQualityMode", "Off", "", "OFF")
    strategy.parameters:addStringAlternative("EntryQualityMode", "Observe (log only)", "", "OBSERVE")
    strategy.parameters:addStringAlternative("EntryQualityMode", "Enforce (block failures)", "", "ENFORCE")
    strategy.parameters:addDouble("EntryMinBodyATR", "Minimum Trigger Body, ATR", "Directional candle body for EMA pullback/continuation quality. OBSERVE default only records pass/fail", 0.20, 0.0, 2.0)
    strategy.parameters:addDouble("EntryMinCloseLoc", "Minimum Directional Close Location", "Long close in top portion of candle; short is mirrored. OBSERVE default only records pass/fail", 0.65, 0.5, 1.0)
    strategy.parameters:addDouble("EntryMaxBodyATR", "Maximum Trigger Body, ATR", "Flags potentially exhausted trigger candles. 0 disables", 1.6, 0.0, 6.0)
    strategy.parameters:addBoolean("EntryRequireBreakPriorBar", "Require Prior-Bar Break", "Long must close above prior high; short below prior low. OBSERVE default only records pass/fail", true)
    strategy.parameters:addDouble("EntryMinRoomATR", "Minimum Room To Recent Extreme, ATR", "Minimum room toward the recent high/low for pullback and continuation candidates. 0 disables", 0.75, 0.0, 5.0)
    strategy.parameters:addInteger("EntryRoomLookback", "Room Lookback, Bars", "Closed bars used to locate the recent high/low", 30, 5, 200)
    strategy.parameters:addDouble("EntryMaxSpreadStopRatio", "Maximum Spread / Stop Distance", "Flags entries where current spread is a large share of planned stop distance. 0 disables", 0.20, 0.0, 1.0)
    strategy.parameters:addDouble("EntryMaxRSILong", "Maximum RSI For Longs", "Flags overbought long triggers. 100 disables", 78.0, 50.0, 100.0)
    strategy.parameters:addDouble("EntryMinRSIShort", "Minimum RSI For Shorts", "Flags oversold short triggers. 0 disables", 22.0, 0.0, 50.0)
    strategy.parameters:addDouble("EntryMinEfficiency", "Minimum Price Efficiency", "Flags low directional efficiency. 0 disables", 0.05, 0.0, 1.0)
    strategy.parameters:addInteger("EntryFastLossBars", "Fast Loss Definition, Bars", "A loss closed within this many bars is considered a fast failure", 8, 1, 60)
    strategy.parameters:addInteger("EntryFastLossLockBars", "Same-Side Lock After Fast Loss, Bars", "ENFORCE only: block same-side entries for this many bars after a fast loss. 0 disables", 15, 0, 200)

    strategy.parameters:addGroup("Execution Quality (Closed Bars)")
    strategy.parameters:addString("ExecutionQualityMode", "Execution Quality Mode", "OBSERVE logs spread costs; FILTER also blocks costly entries; uses candle-close quotes, not order flow", "OBSERVE")
    strategy.parameters:addStringAlternative("ExecutionQualityMode", "Off", "", "OFF")
    strategy.parameters:addStringAlternative("ExecutionQualityMode", "Observe", "", "OBSERVE")
    strategy.parameters:addStringAlternative("ExecutionQualityMode", "Filter entries", "", "FILTER")
    strategy.parameters:addInteger("ExecutionLookback", "Prior Spread Bars", "Excludes the current candle", 30, 5, 200)
    strategy.parameters:addInteger("ExecutionMinSamples", "Minimum Baseline Samples", "Relative spread filter waits for this many valid prior bars", 10, 1, 200)
    strategy.parameters:addDouble("ExecutionMaxSpreadATR", "Maximum Spread / ATR", "FILTER only; price-unit spread divided by ATR; requires validation for your feed", 0.30, 0.01, 2.0)
    strategy.parameters:addDouble("ExecutionMaxSpreadRatio", "Maximum Spread / Prior Mean", "FILTER only; current spread versus prior valid candle-close spreads", 2.0, 1.0, 10.0)

    strategy.parameters:addGroup("Diagnostics")
    strategy.parameters:addBoolean("ShowDebug", "Debug Logging", "Print per-bar decision diagnostics to the terminal", true)
    strategy.parameters:addBoolean("ShowCleanDiagnostics", "Show Clean Engine Diagnostics", "Always print v9.1 clean state/setup/action diagnostics on every closed bar, independent of Debug Logging", true)
    strategy.parameters:addBoolean("CompactDiagnostics", "Compact Diagnostics", "Short plain-English decision, main blockers, market pressure and next condition. CSV retains full reasons and evidence", true)
    strategy.parameters:addBoolean("WriteCSVLogFile", "Write CSV Log File", "Create daily instrument/timeframe logs with BAR, TRADE_OPEN, TRADE_UPDATE, and TRADE_CLOSE analytics; logging failure never changes trading decisions", false)
    strategy.parameters:addString("CSVLogFile", "CSV Log File", "Destination folder, or a legacy .csv path whose directory will be used. Files are named automatically, for example GER30_M5_2026-08-13.csv", "adaptive_regime_strategy_v6_27_7.csv")
    strategy.parameters:addBoolean("ShowAlerts", "Show Trade Alerts", "", true)
end

-- =========================
-- Prepare
-- =========================
function Prepare(nameOnly)
    Cfg.PullbackMinRetraceATR = instance.parameters.PullbackMinRetraceATR or 0.2
    Cfg.PullbackMaxAgeBars = instance.parameters.PullbackMaxAgeBars or 5
    Cfg.PullbackMinReclaimATR = instance.parameters.PullbackMinReclaimATR or 0.05
    Cfg.PullbackMinBodyATR = instance.parameters.PullbackMinBodyATR or 0.1
    Cfg.PullbackMaxAdverseATR = instance.parameters.PullbackMaxAdverseATR or 0.75
    Cfg.PullbackMaxVWAPATR = instance.parameters.PullbackMaxVWAPATR or 1.25
    Cfg.PullbackMaxLongRSI = instance.parameters.PullbackMaxLongRSI or 68
    Cfg.PullbackMinShortRSI = instance.parameters.PullbackMinShortRSI or 32
    Cfg.ExecutionQualityMode = instance.parameters.ExecutionQualityMode or "OBSERVE"
    Cfg.ExecutionLookback = instance.parameters.ExecutionLookback or 30
    Cfg.ExecutionMinSamples = instance.parameters.ExecutionMinSamples or 10
    Cfg.ExecutionMaxSpreadATR = instance.parameters.ExecutionMaxSpreadATR or 0.30
    Cfg.ExecutionMaxSpreadRatio = instance.parameters.ExecutionMaxSpreadRatio or 2.0
    assert(Cfg.ExecutionQualityMode == "OFF" or Cfg.ExecutionQualityMode == "OBSERVE" or Cfg.ExecutionQualityMode == "FILTER", "Invalid Execution Quality Mode")
    assert(Cfg.ExecutionMinSamples <= Cfg.ExecutionLookback, "Execution baseline minimum must not exceed its lookback")
    Cfg.BidOrAsk = instance.parameters.BidOrAsk
    Cfg.TF = instance.parameters.TF
    Cfg.UseHTF = instance.parameters.UseHTF
    Cfg.HTF = instance.parameters.HTF
    Cfg.HTFMaxAgeMinutes = instance.parameters.HTFMaxAgeMinutes
    Cfg.HTFMAMethod = instance.parameters.HTFMAMethod
    Cfg.HTFMAPeriod = instance.parameters.HTFMAPeriod
    Cfg.HTFATRPeriod = instance.parameters.HTFATRPeriod
    Cfg.HTFOppositionMinGapATR = instance.parameters.HTFOppositionMinGapATR
    Cfg.HTFOppositionMinSlopeATR = instance.parameters.HTFOppositionMinSlopeATR
    Cfg.HTFAllowNeutral = instance.parameters.HTFAllowNeutral
    Cfg.HTFOppositionMode = instance.parameters.HTFOppositionMode
    if Cfg.HTFOppositionMode ~= "BLOCK" then Cfg.HTFOppositionMode = "EVIDENCE" end
    Cfg.MAMethod = instance.parameters.MAMethod
    Cfg.FastPeriod = instance.parameters.FastPeriod
    Cfg.MediumPeriod = instance.parameters.MediumPeriod
    Cfg.SlowPeriod = instance.parameters.SlowPeriod
    Cfg.RSIPeriod = instance.parameters.RSIPeriod
    Cfg.ATRPeriod = instance.parameters.ATRPeriod
    Cfg.ADXPeriod = instance.parameters.ADXPeriod
    Cfg.BBPeriod = instance.parameters.BBPeriod
    Cfg.SwingPeriod = instance.parameters.SwingPeriod
    Cfg.StatsPeriod = instance.parameters.StatsPeriod
    Cfg.MomentumPeriod = instance.parameters.MomentumPeriod
    Cfg.StructurePivotStrength = instance.parameters.StructurePivotStrength
    Cfg.StructureMinPivotATR = instance.parameters.StructureMinPivotATR
    Cfg.UseStructureDirectionWeight = instance.parameters.UseStructureDirectionWeight
    Cfg.StructureDirectionWeight = instance.parameters.StructureDirectionWeight
    Cfg.UseEnhancedStructure = instance.parameters.UseEnhancedStructure
    Cfg.StructureMaxPivotAgeBars = instance.parameters.StructureMaxPivotAgeBars
    Cfg.OpposingCHOCHHardBlock = instance.parameters.OpposingCHOCHHardBlock
    Cfg.RegimeThreshold = instance.parameters.RegimeThreshold
    Cfg.ReversalThreshold = instance.parameters.ReversalThreshold
    Cfg.RegimeConfidenceMargin = instance.parameters.RegimeConfidenceMargin
    Cfg.TrendBreakoutConfidenceBonus = instance.parameters.TrendBreakoutConfidenceBonus
    Cfg.TradeTypeProfile = instance.parameters.TradeTypeProfile
    Cfg.ActivityProfile = instance.parameters.ActivityProfile or "AGGRESSIVE"
    Cfg.ApplyActivityProfileAllTF = instance.parameters.ApplyActivityProfileAllTF == true
    Cfg.AllowTrendTrades = instance.parameters.AllowTrendTrades
    Cfg.AllowBreakoutTrades = instance.parameters.AllowBreakoutTrades
    Cfg.AllowRangeTrades = instance.parameters.AllowRangeTrades
    Cfg.AllowReversalTrades = instance.parameters.AllowReversalTrades
    Cfg.AllowVWAPFadeTrades = instance.parameters.AllowVWAPFadeTrades
    Cfg.UseSmartMarketState = instance.parameters.UseSmartMarketState
    Cfg.SmartStateMinConfidence = instance.parameters.SmartStateMinConfidence
    Cfg.SmartStateHysteresis = instance.parameters.SmartStateHysteresis
    Cfg.SmartStateMaxHoldBars = instance.parameters.SmartStateMaxHoldBars or 3
    -- Both visible switches are permissions: either OFF disables fades.
    Cfg.UseVWAPFade = instance.parameters.UseVWAPFade
        and instance.parameters.AllowVWAPFadeTrades ~= false
    Cfg.VWAPFadeMinATR = instance.parameters.VWAPFadeMinATR
    Cfg.VWAPFadeRSIHigh = instance.parameters.VWAPFadeRSIHigh
    Cfg.VWAPFadeRSILow = instance.parameters.VWAPFadeRSILow
    Cfg.VWAPFadeRequireRejection = instance.parameters.VWAPFadeRequireRejection
    Cfg.VWAPFadeMaxADX = instance.parameters.VWAPFadeMaxADX
    Cfg.RequireDominantDirectionalRegime = instance.parameters.RequireDominantDirectionalRegime
    Cfg.MinimumTrendADX = instance.parameters.MinimumTrendADX
    Cfg.RequireDirectionalDMIAlignment = instance.parameters.RequireDirectionalDMIAlignment
    Cfg.ProbabilityScoreMin = instance.parameters.ProbabilityScoreMin
    Cfg.ProbabilityEdgeMin = instance.parameters.ProbabilityEdgeMin
    Cfg.ProbabilityRequireHTFData = instance.parameters.ProbabilityRequireHTFData
    Cfg.UseSmartEvidence = instance.parameters.UseSmartEvidence
    Cfg.RequireEvidenceCoherence = instance.parameters.RequireEvidenceCoherence
    Cfg.ProbabilityUseStateAI = instance.parameters.ProbabilityUseStateAI
    Cfg.StateAIScoreBoostMax = instance.parameters.StateAIScoreBoostMax
    Cfg.StateAILowConfScoreAdd = instance.parameters.StateAILowConfScoreAdd
    Cfg.MinBucketDirection = instance.parameters.MinBucketDirection
    Cfg.MinBucketStructure = instance.parameters.MinBucketStructure
    Cfg.MinBucketLocation = instance.parameters.MinBucketLocation
    Cfg.MinBucketMomentum = instance.parameters.MinBucketMomentum
    Cfg.SmartHTFOpposedScoreAdd = instance.parameters.SmartHTFOpposedScoreAdd
    Cfg.SmartHTFOpposedEdgeAdd = instance.parameters.SmartHTFOpposedEdgeAdd
    Cfg.SmartThinMarginScoreAdd = instance.parameters.SmartThinMarginScoreAdd
    Cfg.SmartHighVolScoreAdd = instance.parameters.SmartHighVolScoreAdd
    Cfg.SmartAgreementBonusMax = instance.parameters.SmartAgreementBonusMax
    Cfg.ProbabilityPullbackMaxEntryGapATR = instance.parameters.ProbabilityPullbackMaxEntryGapATR
    Cfg.VWAPStretchATR = instance.parameters.VWAPStretchATR
    Cfg.TrendMaxExtensionATR = instance.parameters.TrendMaxExtensionATR
    Cfg.TrendEntryMode = instance.parameters.TrendEntryMode
    Cfg.TrendPullbackLookbackBars = instance.parameters.TrendPullbackLookbackBars
    assert(Cfg.PullbackMaxAgeBars <= Cfg.TrendPullbackLookbackBars, "Pullback age must not exceed lookback")
    Cfg.TrendPullbackTouchATR = instance.parameters.TrendPullbackTouchATR
    Cfg.TrendPullbackMaxCloseATR = instance.parameters.TrendPullbackMaxCloseATR
    Cfg.UseEarlyTrendBreakout = instance.parameters.UseEarlyTrendBreakout
    Cfg.EarlyBreakoutMinMomentumATR = instance.parameters.EarlyBreakoutMinMomentumATR
    Cfg.EarlyBreakoutMinDMIRatio = instance.parameters.EarlyBreakoutMinDMIRatio
    Cfg.EarlyBreakoutMinADX = instance.parameters.EarlyBreakoutMinADX
    Cfg.EarlyBreakoutMaxFastMAGapATR = instance.parameters.EarlyBreakoutMaxFastMAGapATR
    Cfg.EarlyBreakoutMaxVWAPExtensionATR = instance.parameters.EarlyBreakoutMaxVWAPExtensionATR
    Cfg.BreakoutMaxExtensionATR = instance.parameters.BreakoutMaxExtensionATR
    Cfg.RangeEdgeFraction = instance.parameters.RangeEdgeFraction
    Cfg.BreakoutATRMin = instance.parameters.BreakoutATRMin
    Cfg.BreakoutCompressionLookback = instance.parameters.BreakoutCompressionLookback
    Cfg.CompressionATRPctMax = instance.parameters.CompressionATRPctMax
    Cfg.CompressionBBPctMax = instance.parameters.CompressionBBPctMax
    Cfg.CompressionRangeATRMax = instance.parameters.CompressionRangeATRMax
    Cfg.LargeCandleATR = instance.parameters.LargeCandleATR
    Cfg.EntryEngineMode = instance.parameters.EntryEngineMode or (instance.parameters.UseCleanV91EntryEngine and "CLEAN" or "LEGACY_V1")
    Cfg.OnlyEMAPullbacks = instance.parameters.OnlyEMAPullbacks ~= false
    Cfg.LegacyV2TrendMinEvidence = instance.parameters.LegacyV2TrendMinEvidence or 60.0
    Cfg.LegacyV2RangeMinEvidence = instance.parameters.LegacyV2RangeMinEvidence or 55.0
    Cfg.LegacyV2FadeMinEvidence = instance.parameters.LegacyV2FadeMinEvidence or 55.0
    Cfg.LegacyV2MinDirection = instance.parameters.LegacyV2MinDirection or 10.0
    Cfg.LegacyV2MinStructure = instance.parameters.LegacyV2MinStructure or 8.0
    Cfg.LegacyV2MinLocation = instance.parameters.LegacyV2MinLocation or 8.0
    Cfg.LegacyV2MinMomentum = instance.parameters.LegacyV2MinMomentum or 6.0
    Cfg.LegacyV2SmartStatePolicy = instance.parameters.LegacyV2SmartStatePolicy or "EVIDENCE"
    Cfg.LegacyV2SmartStateBonus = instance.parameters.LegacyV2SmartStateBonus or 5.0
    Cfg.LegacyV2StrictMinConfidence = instance.parameters.LegacyV2StrictMinConfidence or 60.0
    Cfg.ATRStopTrend = instance.parameters.ATRStopTrend
    Cfg.ATRStopRange = instance.parameters.ATRStopRange
    Cfg.ATRStopBreakout = instance.parameters.ATRStopBreakout
    Cfg.ATRStopReversal = instance.parameters.ATRStopReversal
    Cfg.MinStopATR = instance.parameters.MinStopATR
    Cfg.UseCleanV91EntryEngine = Cfg.EntryEngineMode == "CLEAN" or Cfg.EntryEngineMode == "HYBRID_CONFIRM" or Cfg.EntryEngineMode == "SHADOW"
    Cfg.CleanPullbackMode = instance.parameters.CleanPullbackMode or "UPGRADED"
    Cfg.CleanPullbackMinScore = instance.parameters.CleanPullbackMinScore or 60
    Cfg.CleanPullbackMinSlopeATR = instance.parameters.CleanPullbackMinSlopeATR or 0.0
    Cfg.CleanPullbackMaxAdverseATR = instance.parameters.CleanPullbackMaxAdverseATR or 0.75
    Cfg.CleanRequireFullEMAStack = instance.parameters.CleanRequireFullEMAStack
    Cfg.CleanMinEntryScore = instance.parameters.CleanMinEntryScore
    Cfg.CleanMinDMIRatio = instance.parameters.CleanMinDMIRatio
    Cfg.CleanImpulseStateATR = instance.parameters.CleanImpulseStateATR
    Cfg.CleanTransitionADX = instance.parameters.CleanTransitionADX
    Cfg.CleanTransitionDMIRatio = instance.parameters.CleanTransitionDMIRatio
    Cfg.CleanTransitionMomentumATR = instance.parameters.CleanTransitionMomentumATR
    Cfg.CleanRangeMaxADX = instance.parameters.CleanRangeMaxADX
    Cfg.CleanRangeMaxMACompressionATR = instance.parameters.CleanRangeMaxMACompressionATR
    Cfg.CleanRangeMaxMomentumATR = instance.parameters.CleanRangeMaxMomentumATR
    Cfg.CleanTriggerBodyATR = instance.parameters.CleanTriggerBodyATR
    Cfg.CleanTriggerCloseLoc = instance.parameters.CleanTriggerCloseLoc
    Cfg.CleanContinuationMomentumATR = instance.parameters.CleanContinuationMomentumATR
    Cfg.CleanContinuationEMARejectATR = instance.parameters.CleanContinuationEMARejectATR
    Cfg.CleanContinuationMaxFastGapATR = instance.parameters.CleanContinuationMaxFastGapATR
    Cfg.CleanContinuationMaxMomentumATR = instance.parameters.CleanContinuationMaxMomentumATR
    Cfg.CleanContinuationRebaseLookback = instance.parameters.CleanContinuationRebaseLookback
    Cfg.CleanContinuationRebaseTouchATR = instance.parameters.CleanContinuationRebaseTouchATR
    Cfg.CleanUseVWAPQuality = instance.parameters.CleanUseVWAPQuality
    Cfg.BlockEntriesFarFromVWAP = instance.parameters.BlockEntriesFarFromVWAP == true
    Cfg.MaxEntryVWAPDistanceATR = instance.parameters.MaxEntryVWAPDistanceATR or 6.0
    Cfg.CleanVWAPAlignedBonus = instance.parameters.CleanVWAPAlignedBonus
    Cfg.CleanVWAPOpposedPenalty = instance.parameters.CleanVWAPOpposedPenalty
    Cfg.CleanContinuationMaxVWAPStretchATR = instance.parameters.CleanContinuationMaxVWAPStretchATR
    Cfg.CleanBreakoutMaxVWAPStretchATR = instance.parameters.CleanBreakoutMaxVWAPStretchATR
    Cfg.CleanPullbackVWAPPenaltyConfiguredATR = tonumber(instance.parameters.CleanPullbackVWAPPenaltyATR) or 3.0
    Cfg.CleanPullbackVWAPPenaltyATR = Cfg.CleanPullbackVWAPPenaltyConfiguredATR
    Cfg.CleanPullbackMaxVWAPStretchATR = tonumber(instance.parameters.CleanPullbackMaxVWAPStretchATR) or 4.5
    Cfg.CleanPullbackVWAPPenaltyNormalized = false
    -- Existing FXCM instances keep saved input values after a script update.
    -- If an old penalty start lies beyond its hard cap, move only the effective
    -- runtime threshold to 75% of the cap so an actual penalty zone exists.
    if Cfg.CleanPullbackVWAPPenaltyATR >= Cfg.CleanPullbackMaxVWAPStretchATR then
        Cfg.CleanPullbackVWAPPenaltyATR = Cfg.CleanPullbackMaxVWAPStretchATR * 0.75
        Cfg.CleanPullbackVWAPPenaltyNormalized = true
    end
    Cfg.CleanPullbackVWAPPenaltyScore = instance.parameters.CleanPullbackVWAPPenaltyScore
    Cfg.CleanPullbackStateMaxCounterMomentumATR = instance.parameters.CleanPullbackStateMaxCounterMomentumATR
    Cfg.CleanPullbackTouchATR = instance.parameters.CleanPullbackTouchATR
    Cfg.CleanPullbackReclaimATR = instance.parameters.CleanPullbackReclaimATR
    Cfg.CleanPullbackRetestLookbackBars = instance.parameters.CleanPullbackRetestLookbackBars or 2
    Cfg.CleanPullbackMinDMIRatio = instance.parameters.CleanPullbackMinDMIRatio
    Cfg.CleanPullbackMaxFastGapATR = instance.parameters.CleanPullbackMaxFastGapATR
    Cfg.CleanBreakoutLookback = instance.parameters.CleanBreakoutLookback
    Cfg.CleanRangeLookback = instance.parameters.CleanRangeLookback
    Cfg.CleanBreakoutBufferATR = instance.parameters.CleanBreakoutBufferATR
    Cfg.CleanBreakoutMomentumATR = instance.parameters.CleanBreakoutMomentumATR
    Cfg.CleanBreakoutMinADX = instance.parameters.CleanBreakoutMinADX
    Cfg.CleanBreakoutMinDMIRatio = instance.parameters.CleanBreakoutMinDMIRatio
    Cfg.CleanBreakoutBodyATR = instance.parameters.CleanBreakoutBodyATR
    Cfg.CleanBreakoutCloseLoc = instance.parameters.CleanBreakoutCloseLoc
    Cfg.CleanBreakoutMaxFastGapATR = instance.parameters.CleanBreakoutMaxFastGapATR
    Cfg.CleanAllowRange = instance.parameters.CleanAllowRange
    Cfg.CleanRangeEdgeFraction = instance.parameters.CleanRangeEdgeFraction
    Cfg.CleanRangeLongMaxRSI = instance.parameters.CleanRangeLongMaxRSI
    Cfg.CleanRangeShortMinRSI = instance.parameters.CleanRangeShortMinRSI
    Cfg.CleanRangeMinScore = instance.parameters.CleanRangeMinScore
    Cfg.CleanRangeUseVWAPMeanReversion = instance.parameters.CleanRangeUseVWAPMeanReversion
    Cfg.CleanRangeRequire2RRoom = instance.parameters.CleanRangeRequire2RRoom
    Cfg.UseRangeStopWidthGate = instance.parameters.UseRangeStopWidthGate ~= false
    Cfg.MaxRangeStopFraction = instance.parameters.MaxRangeStopFraction or 0.50
    Cfg.CleanRangeBreakoutCandleATR = instance.parameters.CleanRangeBreakoutCandleATR
    Cfg.CleanRangeDangerDMIRatio = instance.parameters.CleanRangeDangerDMIRatio
    Cfg.CleanRangeDangerMomentumATR = instance.parameters.CleanRangeDangerMomentumATR
    Cfg.CleanRangeDangerADX = instance.parameters.CleanRangeDangerADX
    Cfg.MinStopPips = instance.parameters.MinStopPips
    Cfg.StopSpreadMultiple = instance.parameters.StopSpreadMultiple
    Cfg.VolatilityLookback = instance.parameters.VolatilityLookback or 50
    Cfg.UseVolatilityStopWidening = instance.parameters.UseVolatilityStopWidening ~= false
    Cfg.VolWidenStartPct = instance.parameters.VolWidenStartPct or 0.75
    Cfg.VolWidenFullPct = instance.parameters.VolWidenFullPct or 1.00
    if Cfg.VolWidenFullPct <= Cfg.VolWidenStartPct then
        Cfg.VolWidenFullPct = min(1.0, Cfg.VolWidenStartPct + 0.01)
    end
    Cfg.VolWidenMax = instance.parameters.VolWidenMax or 0.25
    Cfg.FixedStopVolatilityPolicy = instance.parameters.FixedStopVolatilityPolicy or "FIXED_WITH_FLOORS"
    Cfg.MaxEntryStopPips = instance.parameters.MaxEntryStopPips or 40.0
    Cfg.VolRiskP25 = instance.parameters.VolRiskP25 or 0.85
    Cfg.VolRiskP50 = instance.parameters.VolRiskP50 or 1.00
    Cfg.VolRiskP60 = instance.parameters.VolRiskP60 or 0.95
    Cfg.VolRiskP70 = instance.parameters.VolRiskP70 or 0.90
    Cfg.VolRiskP80 = instance.parameters.VolRiskP80 or 0.82
    Cfg.VolRiskP90 = instance.parameters.VolRiskP90 or 0.75
    Cfg.VolRiskP100 = instance.parameters.VolRiskP100 or 0.70
    Cfg.RRTrend = instance.parameters.RRTrend
    Cfg.RRRange = instance.parameters.RRRange
    Cfg.RRBreakout = instance.parameters.RRBreakout
    Cfg.RRReversal = instance.parameters.RRReversal
    Cfg.BreakEvenR = instance.parameters.BreakEvenR
    Cfg.TrailATR = instance.parameters.TrailATR
    Cfg.MinTrailPips = instance.parameters.MinTrailPips
    Cfg.MaxBarsInTrade = instance.parameters.MaxBarsInTrade
    Cfg.UseSmartMoneyManagement = instance.parameters.UseSmartMoneyManagement
    Cfg.ScaleRiskByQuality = instance.parameters.ScaleRiskByQuality
    Cfg.RiskScaleMin = instance.parameters.RiskScaleMin
    Cfg.RiskScaleMax = instance.parameters.RiskScaleMax
    if Cfg.RiskScaleMin > Cfg.RiskScaleMax then
        Cfg.RiskScaleMin, Cfg.RiskScaleMax = Cfg.RiskScaleMax, Cfg.RiskScaleMin
    end
    Cfg.ScaleRiskByLossStreak = instance.parameters.ScaleRiskByLossStreak
    Cfg.LossStreakFactor = instance.parameters.LossStreakFactor
    Cfg.ScaleRiskByDrawdown = instance.parameters.ScaleRiskByDrawdown
    Cfg.DrawdownScaleStartPct = instance.parameters.DrawdownScaleStartPct
    Cfg.ExitOnRegimeFlip = instance.parameters.ExitOnRegimeFlip
    Cfg.ExitOnThesisInvalidation = instance.parameters.ExitOnThesisInvalidation
    Cfg.UseSmartTradeManagement = instance.parameters.UseSmartTradeManagement
    Cfg.LockProfitR = instance.parameters.LockProfitR
    Cfg.LockProfitFraction = instance.parameters.LockProfitFraction
    Cfg.TrailTightenAfterR = instance.parameters.TrailTightenAfterR
    Cfg.TrailTightenFactor = instance.parameters.TrailTightenFactor
    Cfg.ExitOnAdverseCHOCH = instance.parameters.ExitOnAdverseCHOCH
    Cfg.UseGivebackExit = instance.parameters.UseGivebackExit
    Cfg.GivebackArmR = instance.parameters.GivebackArmR
    Cfg.GivebackFloorR = instance.parameters.GivebackFloorR
    Cfg.UseVolumeFilter = instance.parameters.UseVolumeFilter
    Cfg.VolumeLookback = instance.parameters.VolumeLookback
    Cfg.VolumeFactor = instance.parameters.VolumeFactor
    Cfg.AllowTrade = instance.parameters.AllowTrade
    Cfg.AccountType = instance.parameters.AccountType
    Cfg.AllowedSide = instance.parameters.ALLOWEDSIDE
    Cfg.AllowMultiple = instance.parameters.AllowMultiple
    Cfg.OneTradePerDirection = instance.parameters.OneTradePerDirection
    Rt.Account = instance.parameters.Account
    Cfg.Amount = instance.parameters.Amount
    Cfg.SetLimit = instance.parameters.SetLimit
    Cfg.Limit = instance.parameters.Limit
    Cfg.SetStop = instance.parameters.SetStop
    Cfg.Stop = instance.parameters.Stop
    Cfg.TrailingStop = instance.parameters.TrailingStop
    Cfg.SizingMode = instance.parameters.SizingMode
    Cfg.CustomID = instance.parameters.CustomID
    Cfg.MaxPositions = instance.parameters.MaxPositions
    Cfg.MinBarsBetweenTrades = instance.parameters.MinBarsBetweenTrades
    Cfg.SetupResetBars = instance.parameters.SetupResetBars
    Cfg.PendingOpenTimeoutBars = instance.parameters.PendingOpenTimeoutBars
    Cfg.PendingCloseTimeoutBars = instance.parameters.PendingCloseTimeoutBars
    Cfg.MaxSpreadPips = instance.parameters.MaxSpreadPips
    Cfg.RiskPct = instance.parameters.RiskPct
    Cfg.FixedLotRiskGuard = instance.parameters.FixedLotRiskGuard ~= false
    Cfg.MaxOpenRiskPct = instance.parameters.MaxOpenRiskPct or 2.0
    Cfg.RiskSlippagePips = instance.parameters.RiskSlippagePips or 1.0
    Cfg.RoundTripCommissionPerLot = instance.parameters.RoundTripCommissionPerLot or 0
    Cfg.MinNetRewardRisk = instance.parameters.MinNetRewardRisk or 1.0
    Cfg.PipValueMode = instance.parameters.PipValueMode or "AUTO_BROKER"
    if Cfg.PipValueMode ~= "MANUAL" then Cfg.PipValueMode = "AUTO_BROKER" end
    Cfg.PipValuePerBaseUnit = instance.parameters.PipValuePerBaseUnit -- manual override only
    Cfg.MaxUnits = instance.parameters.MaxUnits
    Cfg.MaxTotalUnits = instance.parameters.MaxTotalUnits
    Cfg.MinLots = instance.parameters.MinLots
    Cfg.MaxLots = instance.parameters.MaxLots
    Cfg.MaxDailyLossPct = instance.parameters.MaxDailyLossPct
    Cfg.MaxConsecutiveLosses = instance.parameters.MaxConsecutiveLosses
    Cfg.BreakEvenResetsLossStreak = instance.parameters.BreakEvenResetsLossStreak ~= false
    Cfg.UseGlobalSessionFilter = instance.parameters.UseGlobalSessionFilter
    Cfg.TradeSydney = instance.parameters.TradeSydney
    Cfg.TradeSydneyTokyoOverlap = instance.parameters.TradeSydneyTokyoOverlap
    Cfg.TradeTokyo = instance.parameters.TradeTokyo
    Cfg.TradeTokyoLondonOverlap = instance.parameters.TradeTokyoLondonOverlap
    Cfg.TradeLondon = instance.parameters.TradeLondon
    Cfg.TradeLondonNewYorkOverlap = instance.parameters.TradeLondonNewYorkOverlap
    Cfg.TradeNewYork = instance.parameters.TradeNewYork
    Cfg.TradeOffHours = instance.parameters.TradeOffHours
    Cfg.UseKeyLevels = instance.parameters.UseKeyLevels
    Cfg.UseKeyLevelBreakout = instance.parameters.UseKeyLevelBreakout
    Cfg.UseKeyLevelFalseBreakout = instance.parameters.UseKeyLevelFalseBreakout
    Cfg.LondonORMinutes = instance.parameters.LondonORMinutes
    Cfg.KeyLevelBufferATR = instance.parameters.KeyLevelBufferATR
    Cfg.KeyLevelFalseBreakPierceATR = instance.parameters.KeyLevelFalseBreakPierceATR
    Cfg.KeyLevelFalseBreakRequireRejection = instance.parameters.KeyLevelFalseBreakRequireRejection
    Cfg.KeyLevelFalseBreakRSIMax = instance.parameters.KeyLevelFalseBreakRSIMax
    Cfg.KeyLevelFalseBreakRSIMin = instance.parameters.KeyLevelFalseBreakRSIMin
    Cfg.UseNewsFilter = instance.parameters.UseNewsFilter
    Cfg.NewsEventScheduleUTC = instance.parameters.NewsEventScheduleUTC
    Cfg.NewsBlockMinutesBefore = instance.parameters.NewsBlockMinutesBefore
    Cfg.NewsBlockMinutesAfter = instance.parameters.NewsBlockMinutesAfter
    Cfg.NewsRequireFutureEvent = instance.parameters.NewsRequireFutureEvent
    Cfg.MLMode = instance.parameters.MLMode
    Cfg.MLMinSamples = instance.parameters.MLMinSamples
    Cfg.MLProbabilityThreshold = instance.parameters.MLProbabilityThreshold
    Cfg.MLAdaptiveThreshold = instance.parameters.MLAdaptiveThreshold
    Cfg.MLRecentWindow = instance.parameters.MLRecentWindow
    Cfg.MLWeightByR = instance.parameters.MLWeightByR
    Cfg.MLLearningRate = instance.parameters.MLLearningRate
    Cfg.MLL2 = instance.parameters.MLL2
    Cfg.MLMaxAbsWeight = instance.parameters.MLMaxAbsWeight
    Cfg.MLBalanceClasses = instance.parameters.MLBalanceClasses
    Cfg.MLShareAcrossAccounts = instance.parameters.MLShareAcrossAccounts == true
    Cfg.MLModelGroup = tostring(instance.parameters.MLModelGroup or "")
    Cfg.MLPersistModel = instance.parameters.MLPersistModel
    Cfg.MLResetModel = instance.parameters.MLResetModel
    Cfg.EntryQualityMode = instance.parameters.EntryQualityMode or "OBSERVE"
    Cfg.EntryMinBodyATR = instance.parameters.EntryMinBodyATR or 0.20
    Cfg.EntryMinCloseLoc = instance.parameters.EntryMinCloseLoc or 0.65
    Cfg.EntryMaxBodyATR = instance.parameters.EntryMaxBodyATR or 1.6
    Cfg.EntryRequireBreakPriorBar = instance.parameters.EntryRequireBreakPriorBar ~= false
    Cfg.EntryMinRoomATR = instance.parameters.EntryMinRoomATR or 0.75
    Cfg.EntryRoomLookback = instance.parameters.EntryRoomLookback or 30
    Cfg.EntryMaxSpreadStopRatio = instance.parameters.EntryMaxSpreadStopRatio or 0.20
    Cfg.EntryMaxRSILong = instance.parameters.EntryMaxRSILong or 78.0
    Cfg.EntryMinRSIShort = instance.parameters.EntryMinRSIShort or 22.0
    Cfg.EntryMinEfficiency = instance.parameters.EntryMinEfficiency or 0.05
    Cfg.EntryFastLossBars = instance.parameters.EntryFastLossBars or 8
    Cfg.EntryFastLossLockBars = instance.parameters.EntryFastLossLockBars or 15
    Cfg.ShowDebug = instance.parameters.ShowDebug
    Cfg.ShowCleanDiagnostics = instance.parameters.ShowCleanDiagnostics
    Cfg.CompactDiagnostics = instance.parameters.CompactDiagnostics
    Cfg.WriteCSVLogFile = instance.parameters.WriteCSVLogFile
    Cfg.CSVLogFile = instance.parameters.CSVLogFile
    Cfg.ShowAlerts = instance.parameters.ShowAlerts

    -- Activity presets are M1-tuned. Non-M1 defaults to BALANCED operator inputs
    -- unless the operator explicitly enables ApplyActivityProfileAllTF.
    Cfg.applyActivityProfile()
    assert(validNumber(Cfg.RiskPct) and Cfg.RiskPct > 0 and Cfg.RiskPct <= 2,
        "RiskPct must be greater than zero and no more than 2%")
    assert(Cfg.RiskScaleMin > 0 and Cfg.RiskScaleMin <= Cfg.RiskScaleMax
        and Cfg.RiskScaleMax <= 1, "Risk scale must satisfy 0 < min <= max <= 1")
    assert(Cfg.EntryEngineMode == "CLEAN" or Cfg.EntryEngineMode == "LEGACY_V1"
        or Cfg.EntryEngineMode == "LEGACY_V2" or Cfg.EntryEngineMode == "HYBRID_CONFIRM"
        or Cfg.EntryEngineMode == "SHADOW", "Entry Engine Mode must be CLEAN, LEGACY_V1, LEGACY_V2, HYBRID_CONFIRM, or SHADOW")
    assert(Cfg.LegacyV2SmartStatePolicy == "OFF" or Cfg.LegacyV2SmartStatePolicy == "EVIDENCE"
        or Cfg.LegacyV2SmartStatePolicy == "STRICT", "Legacy V2 Smart State Policy must be OFF, EVIDENCE, or STRICT")
    assert(Cfg.LegacyV2TrendMinEvidence >= 0 and Cfg.LegacyV2TrendMinEvidence <= 100
        and Cfg.LegacyV2RangeMinEvidence >= 0 and Cfg.LegacyV2RangeMinEvidence <= 100
        and Cfg.LegacyV2FadeMinEvidence >= 0 and Cfg.LegacyV2FadeMinEvidence <= 100,
        "Legacy V2 evidence thresholds must be 0..100")
    assert(Cfg.CleanMinEntryScore >= 0 and Cfg.CleanMinEntryScore <= 100, "Clean entry score out of range")
    assert(Cfg.CleanPullbackMode == "CLASSIC" or Cfg.CleanPullbackMode == "UPGRADED", "Invalid Clean Pullback Mode")
    assert(validNumber(Cfg.CleanPullbackMinScore) and Cfg.CleanPullbackMinScore >= 0
        and Cfg.CleanPullbackMinScore <= 100, "Invalid upgraded pullback score")
    assert(validNumber(Cfg.CleanPullbackMinSlopeATR) and Cfg.CleanPullbackMinSlopeATR >= 0, "Invalid early trend slope")
    assert(validNumber(Cfg.CleanPullbackMaxAdverseATR) and Cfg.CleanPullbackMaxAdverseATR >= 0, "Invalid pending touch invalidation")
    assert(Cfg.CleanRangeMinScore >= 0 and Cfg.CleanRangeMinScore <= 100, "Clean range score out of range")
    assert(Cfg.CleanRangeDangerADX <= Cfg.CleanRangeMaxADX, "Range danger ADX must be <= Range Maximum ADX")
    assert(validNumber(Cfg.MaxEntryVWAPDistanceATR) and Cfg.MaxEntryVWAPDistanceATR > 0,
        "Maximum Entry Distance From VWAP must be greater than zero")
    assert(Cfg.PipValueMode == "AUTO_BROKER" or Cfg.PipValueMode == "MANUAL",
        "Pip Value Source must be AUTO_BROKER or MANUAL")
    assert(type(Cfg.CleanRequireFullEMAStack) == "boolean", "Clean full EMA stack setting is unavailable")
    assert(Cfg.MaxOpenRiskPct > 0 and Cfg.RiskSlippagePips >= 0
        and Cfg.RoundTripCommissionPerLot >= 0 and Cfg.MinNetRewardRisk >= 0,
        "Invalid monetary risk budget or execution costs")
    assert(Cfg.LockProfitFraction < Cfg.LockProfitR,
        "Locked profit must be below the profit-lock trigger")
    assert(Cfg.GivebackFloorR < Cfg.GivebackArmR,
        "Giveback floor must be below its arming threshold")

    assert(Cfg.TF ~= "t1", "Trading timeframe must be a bar timeframe")
    if Cfg.UseHTF then assert(Cfg.HTF ~= "t1", "Higher timeframe must be a bar timeframe") end
    assert(Cfg.MAMethod == "EMA" or Cfg.MAMethod == "MVA",
        "Main MA Method must be EMA or MVA")
    assert(Cfg.FastPeriod < Cfg.MediumPeriod and Cfg.MediumPeriod < Cfg.SlowPeriod, "MA periods must satisfy Fast < Medium < Slow")
    assert(Cfg.TrendEntryMode == "FAST_MA_PULLBACK" or Cfg.TrendEntryMode == "LEGACY_CONTINUATION",
        "Trend Entry Mode must be FAST_MA_PULLBACK or LEGACY_CONTINUATION")
    assert(Cfg.TradeTypeProfile == "AUTO_SMART" or Cfg.TradeTypeProfile == "TREND_FOCUS"
        or Cfg.TradeTypeProfile == "FADE_FOCUS" or Cfg.TradeTypeProfile == "MANUAL",
        "Trade Type Profile must be AUTO_SMART, TREND_FOCUS, FADE_FOCUS, or MANUAL")
    assert(Cfg.ActivityProfile == "BALANCED" or Cfg.ActivityProfile == "ACTIVE"
        or Cfg.ActivityProfile == "AGGRESSIVE",
        "Activity Profile must be BALANCED, ACTIVE, or AGGRESSIVE")
    assert(Cfg.AllowTrendTrades or Cfg.AllowBreakoutTrades or Cfg.AllowRangeTrades
        or Cfg.AllowReversalTrades or Cfg.UseVWAPFade or Cfg.TradeTypeProfile == "AUTO_SMART",
        "At least one trade type must be enabled")
    assert(Cfg.AccountType == "Automatic" or Cfg.AccountType == "FIFO" or Cfg.AccountType == "NON",
        "Account Type must be Automatic, FIFO, or NON")
    assert(Cfg.AllowedSide == "Both" or Cfg.AllowedSide == "Buy" or Cfg.AllowedSide == "Sell",
        "Allowed side must be Both, Buy, or Sell")
    assert(Cfg.SizingMode == "FixedLots" or Cfg.SizingMode == "AdaptiveRisk",
        "Position Sizing Mode must be FixedLots or AdaptiveRisk")
    assert(Cfg.MinLots <= Cfg.MaxLots,
        "Adaptive Risk minimum lots must not exceed maximum lots")
    if Cfg.UseHTF then
        local mainMinutes = timeframeOrderMinutes(Cfg.TF)
        local htfMinutes = timeframeOrderMinutes(Cfg.HTF)
        assert(mainMinutes ~= nil and htfMinutes ~= nil and htfMinutes > mainMinutes,
            "Higher Timeframe must be strictly longer than Trading Timeframe")
        assert(Cfg.HTFMAMethod == "EMA" or Cfg.HTFMAMethod == "MVA",
            "HTF MA Method must be EMA or MVA")
    end
    assert(type(Cfg.CustomID) == "string" and string.match(Cfg.CustomID, "%S") ~= nil,
        "CustomID must be non-empty")
    assert(Cfg.MLMode == "OFF" or Cfg.MLMode == "OBSERVE" or Cfg.MLMode == "FILTER",
        "MLMode must be OFF, OBSERVE, or FILTER")
    assert(Cfg.EntryQualityMode == "OFF" or Cfg.EntryQualityMode == "OBSERVE" or Cfg.EntryQualityMode == "ENFORCE",
        "EntryQualityMode must be OFF, OBSERVE, or ENFORCE")
    if Cfg.MLShareAcrossAccounts then
        assert(Cfg.MLPersistModel, "Cross-account Smart AI sharing requires model persistence")
        assert(string.match(Cfg.MLModelGroup, "^[%w_%-]+$") ~= nil,
            "Shared Smart AI Model Group must use letters, numbers, underscores, or hyphens")
    end
    if Cfg.AllowTrade then
        assert(Cfg.CustomID ~= Const.CUSTOM_ID_PLACEHOLDER,
            "Set a unique CustomID for this live strategy instance; the placeholder is blocked for safety")
    end

    local name = profile:id() .. "(" .. instance.bid:name() .. "," .. Cfg.TF .. "," .. Cfg.MAMethod .. "," .. Cfg.CustomID .. ")"
    instance:name(name)
    if nameOnly then return end

    debug(string.format("HYBRID ENTRY READY | engineMode=%s onlyEMAPullbacks=%s cleanActive=%s EMA=%d/%d/%d cleanScore=%.0f legacyV2=%.0f/%.0f/%.0f smartStatePolicy=%s MinADX=%.1f DMI=%.2f TransitionADX=%.1f cooldown=%d VWAPQuality=%s FullEMAStack=%s CleanVWAPFade=%s management=SHARED_ALL_MODES continuationMOM=%.2f..%.2f EMA9gap=%.2f rebase=%d",
        tostring(Cfg.EntryEngineMode), tostring(Cfg.OnlyEMAPullbacks), tostring(Cfg.UseCleanV91EntryEngine), Cfg.FastPeriod, Cfg.MediumPeriod, Cfg.SlowPeriod,
        Cfg.CleanMinEntryScore, Cfg.LegacyV2TrendMinEvidence, Cfg.LegacyV2RangeMinEvidence, Cfg.LegacyV2FadeMinEvidence, tostring(Cfg.LegacyV2SmartStatePolicy),
        Cfg.MinimumTrendADX, Cfg.CleanMinDMIRatio, Cfg.CleanTransitionADX, Cfg.MinBarsBetweenTrades, tostring(Cfg.CleanUseVWAPQuality), tostring(Cfg.CleanRequireFullEMAStack), tostring(Cfg.UseVWAPFade),
        Cfg.CleanContinuationMomentumATR, Cfg.CleanContinuationMaxMomentumATR, Cfg.CleanContinuationMaxFastGapATR, Cfg.CleanContinuationRebaseLookback))
    resetRuntimeState()
    debug(string.format("CLEAN_PULLBACK_READY mode=%s qualityMin=%.1f earlySlopes>%.3fATR memory=%d bars adverse=%.2fATR riskQuality=CLASSIC",
        Cfg.CleanPullbackMode,Cfg.CleanPullbackMinScore,Cfg.CleanPullbackMinSlopeATR,
        Cfg.CleanPullbackRetestLookbackBars,Cfg.CleanPullbackMaxAdverseATR))
    Rt.newsEvents, Rt.newsScheduleOK, Rt.newsScheduleStatus = parseNewsSchedule(Cfg.NewsEventScheduleUTC)
    if Cfg.UseNewsFilter and not Rt.newsScheduleOK then
        alert("NEWS FILTER ENABLED BUT UNAVAILABLE: " .. tostring(Rt.newsScheduleStatus) ..
            " | entries will fail closed until the UTC schedule is corrected")
    end
    -- Preserve management of positions using the old shared default, but
    -- never create another position under that collision-prone tag.
    Rt.LegacyCustomIDMode = Cfg.CustomID == "ADAPTIVE_REGIME_TS2"
    Rt.TradingDayOffset = core.host:execute("getTradingDayOffset") or 0
    Rt.TradingWeekOffset = core.host:execute("getTradingWeekOffset") or 0

    Rt.ToTime = instance.parameters.ToTime
    if Rt.ToTime == 1 then Rt.ToTime = core.TZ_EST
    elseif Rt.ToTime == 2 then Rt.ToTime = core.TZ_UTC
    elseif Rt.ToTime == 3 then Rt.ToTime = core.TZ_LOCAL
    elseif Rt.ToTime == 4 then Rt.ToTime = core.TZ_SERVER
    elseif Rt.ToTime == 5 then Rt.ToTime = core.TZ_FINANCIAL
    else Rt.ToTime = core.TZ_TS end

    local ok
    Rt.OpenTime, ok = ParseTime(instance.parameters.StartTime)
    assert(ok, "Invalid StartTime")
    Rt.CloseTime, ok = ParseTime(instance.parameters.StopTime)
    assert(ok, "Invalid StopTime")
    Cfg.UseMandatoryClose = instance.parameters.UseMandatoryClose
    Rt.MandatoryCloseTime, ok = ParseTime(instance.parameters.MandatoryCloseTime)
    assert(ok, "Invalid MandatoryCloseTime")
    Cfg.UseCETLunchBreak = instance.parameters.UseCETLunchBreak
    Rt.CETLunchStart, ok = ParseTime(instance.parameters.CETLunchStart)
    assert(ok, "Invalid CETLunchStart")
    Rt.CETLunchEnd, ok = ParseTime(instance.parameters.CETLunchEnd)
    assert(ok, "Invalid CETLunchEnd")
    Rt.SydneyOpen, ok = ParseTime(instance.parameters.SydneyOpenUTC)
    assert(ok, "Invalid SydneyOpenUTC")
    Rt.SydneyClose, ok = ParseTime(instance.parameters.SydneyCloseUTC)
    assert(ok and Rt.SydneyOpen ~= Rt.SydneyClose, "Invalid SydneyCloseUTC or zero-length Sydney window")
    Rt.TokyoOpen, ok = ParseTime(instance.parameters.TokyoOpenUTC)
    assert(ok, "Invalid TokyoOpenUTC")
    Rt.TokyoClose, ok = ParseTime(instance.parameters.TokyoCloseUTC)
    assert(ok and Rt.TokyoOpen ~= Rt.TokyoClose, "Invalid TokyoCloseUTC or zero-length Tokyo window")
    Rt.LondonOpen, ok = ParseTime(instance.parameters.LondonOpenUTC)
    assert(ok, "Invalid LondonOpenUTC")
    Rt.LondonClose, ok = ParseTime(instance.parameters.LondonCloseUTC)
    assert(ok and Rt.LondonOpen ~= Rt.LondonClose, "Invalid LondonCloseUTC or zero-length London window")
    Rt.AsianRangeOpen, ok = ParseTime(instance.parameters.AsianRangeStartUTC)
    assert(ok, "Invalid AsianRangeStartUTC")
    Rt.AsianRangeClose, ok = ParseTime(instance.parameters.AsianRangeEndUTC)
    assert(ok and Rt.AsianRangeOpen ~= Rt.AsianRangeClose, "Invalid AsianRangeEndUTC or zero-length Asian window")
    Rt.NewYorkOpen, ok = ParseTime(instance.parameters.NewYorkOpenUTC)
    assert(ok, "Invalid NewYorkOpenUTC")
    Rt.NewYorkClose, ok = ParseTime(instance.parameters.NewYorkCloseUTC)
    assert(ok and Rt.NewYorkOpen ~= Rt.NewYorkClose, "Invalid NewYorkCloseUTC or zero-length New York window")
    initializeMLStorage()
    initializeRuntimeStorage()

    local nativeWarmup = max(Cfg.SlowPeriod, max(Cfg.BBPeriod,
        max(Cfg.ATRPeriod, max(Cfg.RSIPeriod, Cfg.ADXPeriod * 2))))
    local mainHistoryCount = max(300, nativeWarmup + max(Cfg.StatsPeriod, Cfg.VolatilityLookback) + 25)
    if Cfg.UseKeyLevels then
        local tfMinutes = timeframeMinutes(Cfg.TF)
        if validNumber(tfMinutes) and tfMinutes > 0 then
            -- Preserve roughly the same elapsed key-level history as the old
            -- 3000-bar M1 subscription while scaling the bar count by TF.
            local keyLevelBars = math.ceil(3000.0 / tfMinutes)
            mainHistoryCount = max(mainHistoryCount, max(300, keyLevelBars))
        else
            -- Monthly/yearly bars have no fixed minute duration. The generic
            -- 300-bar floor is intentionally retained rather than guessing.
            mainHistoryCount = max(mainHistoryCount, 300)
        end
    end
    mainHistoryCount = max(mainHistoryCount, Cfg.SwingPeriod + 25)
    mainHistoryCount = max(mainHistoryCount, Cfg.VolumeLookback + 25)
    mainHistoryCount = max(mainHistoryCount, Cfg.MomentumPeriod + 25)
    mainHistoryCount = max(mainHistoryCount, Cfg.BreakoutCompressionLookback + Cfg.StatsPeriod + 25)
    Rt.Source = subscribeBars(Const.MAIN_SOURCE_ID, Cfg.TF, mainHistoryCount, Cfg.BidOrAsk)
    -- Keep a synchronized opposite-side bar stream so closed-bar stop checks
    -- and spread gates use the executable BID/ASK side instead of NOW.
    local oppositeSource = subscribeBars(Const.EXIT_SOURCE_ID, Cfg.TF, mainHistoryCount, not Cfg.BidOrAsk)
    if Cfg.BidOrAsk then
        Rt.BidSource, Rt.AskSource = Rt.Source, oppositeSource
    else
        Rt.BidSource, Rt.AskSource = oppositeSource, Rt.Source
    end
    if Cfg.UseHTF then
        local htfHistoryCount = max(300, max(Cfg.HTFMAPeriod, Cfg.HTFATRPeriod) + 25)
        Rt.HTFSource = subscribeBars(Const.HTF_SOURCE_ID, Cfg.HTF, htfHistoryCount, Cfg.BidOrAsk)
    else
        Rt.HTFSource = nil
    end

    -- Native FXCM/Indicore indicators. This follows the same creation/update pattern
    -- as the user's working APS strategy: UpdateAll once for warm-up, then UpdateLast.
    Rt.Native = { outputsUpdated = false, htfInitialized = false }
    Rt.lastHTFPeriod = nil
    Rt.Native.maFast = core.indicators:create(Cfg.MAMethod, Rt.Source.close, Cfg.FastPeriod)
    Rt.Native.maMed  = core.indicators:create(Cfg.MAMethod, Rt.Source.close, Cfg.MediumPeriod)
    Rt.Native.maSlow = core.indicators:create(Cfg.MAMethod, Rt.Source.close, Cfg.SlowPeriod)
    if Cfg.MAMethod == "EMA" then
        Rt.Native.maFastData = Rt.Native.maFast.EMA
        Rt.Native.maMedData  = Rt.Native.maMed.EMA
        Rt.Native.maSlowData = Rt.Native.maSlow.EMA
    else
        Rt.Native.maFastData = Rt.Native.maFast.MVA
        Rt.Native.maMedData  = Rt.Native.maMed.MVA
        Rt.Native.maSlowData = Rt.Native.maSlow.MVA
    end
    Rt.Native.atr = core.indicators:create("ATR", Rt.Source, Cfg.ATRPeriod)
    Rt.Native.dmi = core.indicators:create("DMI", Rt.Source, Cfg.ADXPeriod)
    Rt.Native.adx = core.indicators:create("ADX", Rt.Source, Cfg.ADXPeriod)
    Rt.Native.rsi = core.indicators:create("RSI", Rt.Source.close, Cfg.RSIPeriod)
    Rt.Native.bb = core.indicators:create("BB", Rt.Source.close, Cfg.BBPeriod, 2.0)
    assert(core.indicators:findIndicator("VWAP_UTC") ~= nil,
        "Required local indicator VWAP_UTC is not installed")
    Rt.Native.vwap = core.indicators:create("VWAP_UTC", Rt.Source, "typical", 0, false, 1.0, "Session")
    Rt.Native.volumeMVA = nil
    if Cfg.UseVolumeFilter then
        local okVol, volStream = pcall(function() return Rt.Source.volume end)
        if okVol and volStream ~= nil then
            Rt.Native.volumeMVA = core.indicators:create("MVA", volStream, Cfg.VolumeLookback)
        end
    end
    if Cfg.UseHTF and Rt.HTFSource ~= nil then
        Rt.Native.htfMA = core.indicators:create(Cfg.HTFMAMethod, Rt.HTFSource.close, Cfg.HTFMAPeriod)
        if Cfg.HTFMAMethod == "EMA" then
            Rt.Native.htfMAData = Rt.Native.htfMA.EMA
        else
            Rt.Native.htfMAData = Rt.Native.htfMA.MVA
        end
        Rt.Native.htfATR = core.indicators:create("ATR", Rt.HTFSource, Cfg.HTFATRPeriod)
    end

    local offerRow = core.host:findTable("offers"):find("Instrument", instance.bid:instrument())
    assert(offerRow ~= nil, "Offer not found for instrument")
    Rt.Offer = offerRow.OfferID

    if Cfg.AllowTrade then
        assert(Rt.Account ~= nil and Rt.Account ~= "", "Account to trade on must be selected when Allow strategy to trade = Yes")
        local accounts = core.host:findTable("accounts")
        local accountRow = accounts ~= nil and accounts:find("AccountID", Rt.Account) or nil
        assert(accountRow ~= nil, "Selected account was not found in the Accounts table")
        -- Hedging=N means an opposite OM order nets existing positions before
        -- opening any remainder. Unknown capability fails closed as non-hedging.
        local hedgingValue = accountRow.Hedging ~= nil and string.upper(tostring(accountRow.Hedging)) or "N"
        Rt.HedgingEnabled = hedgingValue ~= "N" and hedgingValue ~= "FALSE" and hedgingValue ~= "0"
        Rt.BaseSize = core.host:execute("getTradingProperty", "baseUnitSize", instance.bid:instrument(), Rt.Account)
        assert(Rt.BaseSize ~= nil and Rt.BaseSize > 0, "Unable to resolve baseUnitSize for selected account/instrument")
        if Cfg.AccountType == "FIFO" then
            Rt.CanClose = false
        elseif Cfg.AccountType == "NON" then
            Rt.CanClose = true
        else
            Rt.CanClose = core.host:execute("getTradingProperty", "canCreateMarketClose", instance.bid:instrument(), Rt.Account)
        end
    else
        -- Signal-only mode must not query account trading properties with an empty account.
        Rt.BaseSize = 1
        Rt.CanClose = true
        Rt.HedgingEnabled = true
    end

    if Cfg.AllowTrade and Rt.moneyGuardEnabled() then
        local pipValue, pipReason = Rt.resolvePipValue()
        if not validNumber(pipValue) or pipValue <= 0 then
            alert("NEW ENTRIES BLOCKED: pip value unavailable: " .. tostring(pipReason)
                .. " | mode=" .. tostring(Cfg.PipValueMode) .. " | open-trade protection remains enabled")
        else
            debug(STRATEGY_NAME .. " | " .. Rt.pipValueDiagnostic())
        end
    elseif Cfg.AllowTrade and not Rt.moneyGuardEnabled() then
        alert("MANUAL FIXED LOTS: monetary sizing guard disabled; RiskPct and MaxOpenRiskPct do not cap order size")
    end

    debug("Prepared; Cfg.TF=" .. Cfg.TF .. " Cfg.HTF=" .. tostring(Cfg.HTF)
        .. " ActivityRequested=" .. tostring(Cfg.ActivityProfile)
        .. " ActivityEffective=" .. tostring(Cfg.ActivityEffectiveProfile)
        .. " ActivityAllTF=" .. tostring(Cfg.ApplyActivityProfileAllTF)
        .. " TFMinutes=" .. tostring(timeframeMinutes(Cfg.TF) or "VARIABLE")
        .. " VolLookback=" .. tostring(Cfg.VolatilityLookback)
        .. " MaxEntryStop=" .. tostring(Cfg.MaxEntryStopPips)
        .. " RangeStopFrac=" .. tostring(Cfg.MaxRangeStopFraction)
        .. " VWAPHardBlock=" .. tostring(Cfg.BlockEntriesFarFromVWAP) .. "/" .. tostring(Cfg.MaxEntryVWAPDistanceATR) .. "ATR"
        .. " EntryScore/Edge=" .. tostring(Cfg.ProbabilityScoreMin) .. "/" .. tostring(Cfg.ProbabilityEdgeMin)
        .. " CooldownBars=" .. tostring(Cfg.MinBarsBetweenTrades)
        .. " ExitOnRegimeFlip=" .. tostring(Cfg.ExitOnRegimeFlip)
        .. " ExitOnThesisInvalidation=" .. tostring(Cfg.ExitOnThesisInvalidation)
        .. " BreakEvenResetsLossStreak=" .. tostring(Cfg.BreakEvenResetsLossStreak)
        .. " SetupReuseBars=" .. tostring(Cfg.SetupResetBars)
        .. " StateMin=" .. tostring(Cfg.SmartStateMinConfidence)
        .. " PullbackRetestBars=" .. tostring(Cfg.CleanPullbackRetestLookbackBars)
        .. " PullbackVWAPPenalty="
        .. (Cfg.CleanPullbackVWAPPenaltyNormalized
            and (tostring(Cfg.CleanPullbackVWAPPenaltyConfiguredATR) .. "->") or "")
        .. tostring(Cfg.CleanPullbackVWAPPenaltyATR)
        .. "/" .. tostring(Cfg.CleanPullbackMaxVWAPStretchATR) .. "ATR"
        .. " PullbackVWAPPenaltyState=" .. (not Cfg.CleanUseVWAPQuality and "OFF"
            or Cfg.CleanPullbackVWAPPenaltyNormalized and "NORMALIZED_ACTIVE"
            or Cfg.CleanPullbackVWAPPenaltyATR < Cfg.CleanPullbackMaxVWAPStretchATR and "ACTIVE" or "NO_ZONE")
        .. " AutoFamilyConfidence=" .. tostring(Cfg.ActivityEffectiveProfile == "AGGRESSIVE" and 65 or 50)
        .. " Sizing=" .. tostring(Cfg.SizingMode) .. " RiskQuality=operator-inputs"
        .. " FixedLotRiskGuard=" .. tostring(Cfg.FixedLotRiskGuard)
        .. " PipValueMode=" .. tostring(Cfg.PipValueMode)
        .. " EffectivePipValue=" .. tostring(Rt.EffectivePipValuePerBaseUnit or "NA")
        .. " PipValueSource=" .. tostring(Rt.PipValueSource or "UNRESOLVED")
        .. " ManualPipValue=" .. tostring(Cfg.PipValuePerBaseUnit)
        .. " AdaptiveStatsLookback=" .. tostring(Cfg.StatsPeriod)
        .. " Rt.BaseSize=" .. tostring(Rt.BaseSize)
        .. " Hedging=" .. tostring(Rt.HedgingEnabled)
        .. " CanClose=" .. tostring(Rt.CanClose)
        .. " HTFModel=" .. tostring(Cfg.HTFMAMethod) .. tostring(Cfg.HTFMAPeriod)
        .. "/ATR" .. tostring(Cfg.HTFATRPeriod)
        .. " HTFGap/Slope=" .. tostring(Cfg.HTFOppositionMinGapATR)
        .. "/" .. tostring(Cfg.HTFOppositionMinSlopeATR)
        .. " HTFNeutral=" .. tostring(Cfg.HTFAllowNeutral)
        .. " HTFOppositionMode=" .. tostring(Cfg.HTFOppositionMode)
        .. " OpposingCHOCHHardBlock=" .. tostring(Cfg.OpposingCHOCHHardBlock)
        .. " TrendEntryMode=" .. tostring(Cfg.TrendEntryMode)
        .. " EarlyTrendBreakout=" .. tostring(Cfg.UseEarlyTrendBreakout)
        .. " TradeTypes=Trend:" .. tostring(Cfg.AllowTrendTrades)
        .. "/Breakout:" .. tostring(Cfg.AllowBreakoutTrades)
        .. "/Range:" .. tostring(Cfg.AllowRangeTrades)
        .. "/Reversal:" .. tostring(Cfg.AllowReversalTrades)
        .. " DirectionalQuality=Dominant:" .. tostring(Cfg.RequireDominantDirectionalRegime)
        .. "/MinTrendADX:" .. tostring(Cfg.MinimumTrendADX)
        .. "/DMI:" .. tostring(Cfg.RequireDirectionalDMIAlignment)
        .. " Structure=" .. tostring(Cfg.UseStructureDirectionWeight)
        .. "/pivot" .. tostring(Cfg.StructurePivotStrength)
        .. "/weight" .. tostring(Cfg.StructureDirectionWeight)
        .. "/maxAge" .. tostring(Cfg.StructureMaxPivotAgeBars)
        .. " GlobalSessionFilter=" .. tostring(Cfg.UseGlobalSessionFilter)
        .. " NewsFilter=" .. tostring(Cfg.UseNewsFilter)
        .. " NewsSchedule=" .. tostring(Rt.newsScheduleStatus)
        .. " MLMode=" .. tostring(Cfg.MLMode)
        .. " EntryQuality=" .. tostring(Cfg.EntryQualityMode)
        .. " MLFeatureSchema=" .. tostring(Const.ML_FEATURE_SCHEMA)
        .. " MLFeatureCount=" .. tostring(#ML_FEATURE_NAMES)
        .. " MLExitFeatureSchema=" .. tostring(Const.ML_EXIT_FEATURE_SCHEMA)
        .. " MLExitFeatureCount=" .. tostring(#Const.ML_EXIT_FEATURE_NAMES)
        .. " MLExitSamples=" .. tostring(Rt.ML ~= nil and Rt.ML.exitSamples or 0)
        .. " MLSamples=" .. tostring(Rt.ML ~= nil and Rt.ML.samples or 0))
end

-- =========================
-- Indicator engine
-- =========================
local function rollingMax(stream, p1, p2)
    local v = nil
    for i = p1, p2 do
        if v == nil or stream[i] > v then v = stream[i] end
    end
    return v
end

local function rollingMin(stream, p1, p2)
    local v = nil
    for i = p1, p2 do
        if v == nil or stream[i] < v then v = stream[i] end
    end
    return v
end

local function updateNativeMainIndicators(forceAll)
    if Rt.Native == nil or Rt.Native.maFast == nil then return false end
    -- forceAll re-runs a full UpdateAll even after startup. This is needed
    -- when calculateIndicators() detects a gap in the closed-bar callback
    -- sequence (e.g. a reconnect skipped periods): a plain UpdateLast only
    -- ever advances the native indicator's internal buffer by one bar, so it
    -- cannot recover missed periods on its own.
    local mode = (forceAll or not Rt.Native.outputsUpdated) and core.UpdateAll or core.UpdateLast
    if mode == core.UpdateAll then Rt.efficiencyWindow = nil end
    Rt.Native.maFast:update(mode)
    Rt.Native.maMed:update(mode)
    Rt.Native.maSlow:update(mode)
    Rt.Native.atr:update(mode)
    Rt.Native.dmi:update(mode)
    Rt.Native.adx:update(mode)
    Rt.Native.rsi:update(mode)
    Rt.Native.bb:update(mode)
    Rt.Native.vwap:update(mode)
    if Rt.Native.volumeMVA ~= nil then Rt.Native.volumeMVA:update(mode) end
    Rt.Native.outputsUpdated = true
    return true
end

local function nativeFirstPeriod()
    if Rt.Native == nil or not Rt.Native.outputsUpdated then return nil end
    local first = math.max(
        Rt.Native.maFastData:first(), Rt.Native.maMedData:first(), Rt.Native.maSlowData:first(),
        Rt.Native.atr.ATR:first(), Rt.Native.dmi.DIP:first(), Rt.Native.dmi.DIM:first(),
        Rt.Native.adx.ADX:first(), Rt.Native.rsi.RSI:first(),
        Rt.Native.bb.TL:first(), Rt.Native.bb.BL:first(), Rt.Native.bb.AL:first(),
        Rt.Native.vwap.plot1:first())
    if Rt.Native.volumeMVA ~= nil then first = math.max(first, Rt.Native.volumeMVA.MVA:first()) end
    return first
end

function Rt.efficiencyPath(p)
    local n = Cfg.StatsPeriod
    local state = Rt.efficiencyWindow
    local path
    -- Consecutive closed bars reuse the path sum. Reconnect/backfill, changing
    -- lookback/source bounds and periodic rebasing rebuild the exact window.
    if state ~= nil and state.period == p - 1 and state.length == n
        and state.first == Rt.Source:first() and state.steps < n then
        path = state.path
            - abs(Rt.Source.close[p - n] - Rt.Source.close[p - n - 1])
            + abs(Rt.Source.close[p] - Rt.Source.close[p - 1])
    end
    if path == nil or not validNumber(path) or path < 0 then
        path = 0
        for i = p - n + 1, p do
            path = path + abs(Rt.Source.close[i] - Rt.Source.close[i - 1])
        end
        state = {steps=0}
    else
        state.steps = state.steps + 1
    end
    state.period, state.length, state.first, state.path = p, n, Rt.Source:first(), path
    Rt.efficiencyWindow = state
    return path
end

local function copyNativeBar(p, knownFirst)
    local first = knownFirst or nativeFirstPeriod()
    if first == nil or p < first then return false end
    if not Rt.Source.close:hasData(p) then return false end

    local ef = Rt.Native.maFastData[p]
    local em = Rt.Native.maMedData[p]
    local es = Rt.Native.maSlowData[p]
    local atr = Rt.Native.atr.ATR[p]
    local dip = Rt.Native.dmi.DIP[p]
    local dim = Rt.Native.dmi.DIM[p]
    local adx = Rt.Native.adx.ADX[p]
    local rsi = Rt.Native.rsi.RSI[p]
    local upper = Rt.Native.bb.TL[p]
    local lower = Rt.Native.bb.BL[p]
    local middle = Rt.Native.bb.AL[p]
    local vwap = Rt.Native.vwap.plot1[p]

    if not (validNumber(ef) and validNumber(em) and validNumber(es) and validNumber(atr) and atr > 0
        and validNumber(dip) and validNumber(dim) and validNumber(adx) and validNumber(rsi)
        and validNumber(upper) and validNumber(lower) and validNumber(middle) and validNumber(vwap)) then
        return false
    end

    Ind.emaFast[p], Ind.emaMed[p], Ind.emaSlow[p] = ef, em, es
    Ind.atr[p], Ind.plusDI[p], Ind.minusDI[p], Ind.adx[p], Ind.rsi[p] = atr, dip, dim, adx, rsi
    Ind.bbWidth[p] = safeDiv(upper - lower, middle, 0)
    Ind.vwap[p] = vwap
    if Rt.Native.volumeMVA ~= nil then Ind.avgVolume[p] = Rt.Native.volumeMVA.MVA[p] end

    -- Non-indicator strategy features remain local: prior swing structure
    -- and directional efficiency, used only for context.
    if p - Cfg.SwingPeriod >= Rt.Source:first() then
        Ind.swingHigh[p] = rollingMax(Rt.Source.high, p - Cfg.SwingPeriod, p - 1)
        Ind.swingLow[p] = rollingMin(Rt.Source.low, p - Cfg.SwingPeriod, p - 1)
    end
    if p - Cfg.StatsPeriod >= Rt.Source:first() then
        local path = Rt.efficiencyPath(p)
        Ind.efficiency[p] = safeDiv(abs(Rt.Source.close[p] - Rt.Source.close[p - Cfg.StatsPeriod]), path, 0)
    end
    return true
end

local function calculateIndicators(p)
    -- A gap between the last period this function actually copied and the
    -- period it's now being asked for (e.g. a dropped/skipped ExtUpdate
    -- callback after a reconnect) would otherwise leave Ind.* holes at the
    -- missed periods. Those holes silently distort anything that reads a
    -- rolling window spanning them (ATR/ADX/BB percentiles, VWAP-cross
    -- counts, volatility-expansion checks, regime scores) until the window
    -- moves past the gap - and the stale/missing entries themselves never
    -- get corrected on their own. Detect the gap and force a full native
    -- UpdateAll before recovering every bar the strategy missed, rather than
    -- only ever copying the single bar p.
    local gapDetected = Rt.indHistoryBackfilled and Rt.lastCopiedPeriod ~= nil and p > Rt.lastCopiedPeriod + 1
    local recoveryPending = Rt.copyRecoveryFrom ~= nil
    if not updateNativeMainIndicators(gapDetected or recoveryPending) then return false end

    local first = nativeFirstPeriod()
    if first == nil then return false end
    local startPeriod = p
    if not Rt.indHistoryBackfilled then
        startPeriod = first
    elseif gapDetected then
        startPeriod = Rt.lastCopiedPeriod + 1
    end
    if recoveryPending then
        -- Retry only failures that can still affect a live rolling feature;
        -- permanently unavailable ancient session values must not force an
        -- unbounded UpdateAll/backfill on every future bar.
        local relevantLookback = max(max(Cfg.StatsPeriod, Cfg.VolatilityLookback), max(Cfg.SwingPeriod,
            max(Cfg.VolumeLookback, max(Cfg.MomentumPeriod, Cfg.BreakoutCompressionLookback)))) + 10
        local retryFloor = max(first, p - relevantLookback)
        startPeriod = min(startPeriod, max(Rt.copyRecoveryFrom, retryFloor))
    end

    local firstFailed = nil
    local copiedCurrent = false
    for i = startPeriod, p do
        local copied = copyNativeBar(i, first)
        if not copied and firstFailed == nil then firstFailed = i end
        if i == p then copiedCurrent = copied end
    end
    Rt.indHistoryBackfilled = true
    Rt.copyRecoveryFrom = firstFailed
    if copiedCurrent then Rt.lastCopiedPeriod = p end

    if startPeriod < p then
        local status = firstFailed == nil and "READY" or ("RETRY_FROM=" .. tostring(firstFailed))
        debug(string.format("NATIVE HISTORY %s | copied periods %d..%d (%d bars)", status, startPeriod, p, p-startPeriod+1))
    end
    return copiedCurrent and Ind.atr[p] ~= nil and Ind.rsi[p] ~= nil
        and Ind.adx[p] ~= nil and Ind.vwap[p] ~= nil
end

-- =========================
-- Cfg.HTF context
-- =========================
local function classifyHTFDirection(gapATR, slopeATR)
    if not validNumber(gapATR) or not validNumber(slopeATR) then return 0 end
    local bull = gapATR > 0 and slopeATR > 0
        and gapATR >= Cfg.HTFOppositionMinGapATR
        and slopeATR >= Cfg.HTFOppositionMinSlopeATR
    local bear = gapATR < 0 and slopeATR < 0
        and gapATR <= -Cfg.HTFOppositionMinGapATR
        and slopeATR <= -Cfg.HTFOppositionMinSlopeATR
    if bull then return 1 end
    if bear then return -1 end
    return 0
end

-- Clear directional HTF evidence so a failed update cannot keep the last
-- good trend/date alive. Table method avoids consuming a main-chunk local
-- (Lua 5.1 / Indicore 200-local limit).
local HTFUtil = {}
function HTFUtil.invalidate(status)
    Rt.htfStatus = status or "NO_DATA"
    Rt.htfTrend = 0
    Rt.htfStrength = 0
    Rt.htfGapATR = 0
    Rt.htfSlopeATR = 0
    Rt.htfClose, Rt.htfMAValue, Rt.htfATRValue = nil, nil, nil
    Rt.htfLastDate = nil
    Rt.htfBarDurationMinutes = nil
end

local function updateHTFContext(p)
    if not Cfg.UseHTF or Rt.HTFSource == nil or Rt.Native == nil
        or Rt.Native.htfMA == nil or Rt.Native.htfATR == nil then
        HTFUtil.invalidate("NO_SOURCE")
        return
    end
    if p <= Rt.HTFSource:first() then
        HTFUtil.invalidate("INSUFFICIENT_HISTORY")
        return
    end
    -- A delayed callback must never roll a newer, self-recovered HTF state
    -- backward to an older candle.
    if Rt.lastHTFPeriod ~= nil and p < Rt.lastHTFPeriod then return end
    -- Recover the HTF indicator's internal history after a missed callback.
    -- UpdateLast cannot rebuild skipped EMA/MVA periods after a reconnect.
    local gapDetected = Rt.Native.htfInitialized and Rt.lastHTFPeriod ~= nil
        and p > Rt.lastHTFPeriod + 1
    local mode = (not Rt.Native.htfInitialized or gapDetected) and core.UpdateAll or core.UpdateLast
    Rt.Native.htfMA:update(mode)
    Rt.Native.htfATR:update(mode)
    Rt.Native.htfInitialized = true
    Rt.lastHTFPeriod = p
    local firstValid = max(Rt.Native.htfMAData:first(), Rt.Native.htfATR.ATR:first())
    if p <= firstValid then
        HTFUtil.invalidate("INDICATOR_WARMUP")
        return
    end
    if not Rt.HTFSource.close:hasData(p) then
        HTFUtil.invalidate("PRICE_NO_DATA")
        return
    end
    local htfMAValue = Rt.Native.htfMAData[p]
    local htfATRValue = Rt.Native.htfATR.ATR[p]
    local close = Rt.HTFSource.close[p]
    local prev = Rt.Native.htfMAData[p - 1]
    if not validNumber(htfMAValue) or not validNumber(prev) or not validNumber(close)
        or not validNumber(htfATRValue) or htfATRValue <= 0 then
        HTFUtil.invalidate("INVALID_VALUE")
        return
    end
    local delta = htfMAValue - (prev or htfMAValue)
    Rt.htfGapATR = safeDiv(close - htfMAValue, htfATRValue, 0)
    Rt.htfSlopeATR = safeDiv(delta, htfATRValue, 0)
    Rt.htfTrend = classifyHTFDirection(Rt.htfGapATR, Rt.htfSlopeATR)
    Rt.htfStrength = abs(Rt.htfSlopeATR)
    Rt.htfClose, Rt.htfMAValue, Rt.htfATRValue = close, htfMAValue, htfATRValue
    local openDate = Rt.HTFSource:date(p)
    local endDate = streamBarEndDate(Rt.HTFSource, p, Cfg.HTF)
    if not validNumber(endDate) then
        HTFUtil.invalidate("INVALID_DATE")
        return
    end
    Rt.htfLastDate = endDate
    local duration = validNumber(openDate) and (endDate - openDate) * 1440.0 or nil
    if not validNumber(duration) or duration <= 0 then duration = timeframeMinutes(Cfg.HTF) end
    Rt.htfBarDurationMinutes = duration
    Rt.htfStatus = "READY"
end

-- Find the newest HTF candle whose END is not later than the main candle's
-- end. This makes startup/reconnect independent of callback delivery order
-- without ever reading the still-forming HTF candle.
local function recoverHTFContext(mainEndDate)
    if not Cfg.UseHTF or Rt.HTFSource == nil or not validNumber(mainEndDate) then
        if Cfg.UseHTF then HTFUtil.invalidate("NO_CALLBACK") end
        return
    end
    local ok, size = pcall(function() return Rt.HTFSource:size() end)
    if not ok or type(size) ~= "number" or size <= 0 then
        HTFUtil.invalidate("NO_CALLBACK")
        return
    end
    local first = Rt.HTFSource:first()
    local tolerance = 1.0 / 86400.0 -- one second, for floating date rounding
    for hp = size - 1, first + 1, -1 do
        if Rt.HTFSource.close:hasData(hp) then
            local htfEnd = streamBarEndDate(Rt.HTFSource, hp, Cfg.HTF)
            if validNumber(htfEnd) and htfEnd <= mainEndDate + tolerance then
                if Rt.lastHTFPeriod == nil or hp >= Rt.lastHTFPeriod then updateHTFContext(hp) end
                return
            end
        end
    end
    HTFUtil.invalidate("NO_CLOSED_BAR")
end

local function isHTFStale(mainDate)
    if not Cfg.UseHTF then return false, 0, 0 end
    if mainDate == nil or Rt.htfLastDate == nil then return true, nil, nil end
    local ageMinutes = (mainDate - Rt.htfLastDate) * 24.0 * 60.0
    local mainDuration = timeframeMinutes(Cfg.TF) or 0
    local naturalLimit = (Rt.htfBarDurationMinutes or timeframeMinutes(Cfg.HTF) or 0) + mainDuration
    local limitMinutes = max(Cfg.HTFMaxAgeMinutes, naturalLimit)
    local toleranceMinutes = 1.0 / 60.0 -- one second; absorbs date floating-point noise
    return ageMinutes < -toleranceMinutes or ageMinutes > limitMinutes + toleranceMinutes,
        ageMinutes, limitMinutes
end

-- =========================
-- Context / adaptive stats
-- =========================
local function percentileArray(arr, p, n, value)
    local first = p - n + 1
    if first < Rt.Source:first() then return 0.5 end
    local count, below = 0, 0
    for i = first, p do
        if validNumber(arr[i]) then
            count = count + 1
            if arr[i] <= value then below = below + 1 end
        end
    end
    if count == 0 then return 0.5 end
    return below / count
end

function Rt.volatilityPercentile()
    return clamp(tonumber(Context.volatilityAtrPct or Context.atrPct) or 0.5, 0, 1)
end

function Rt.volatilityState(pct)
    pct = clamp(tonumber(pct) or Rt.volatilityPercentile(), 0, 1)
    if pct <= 0.25 then return "QUIET" end
    if pct >= 0.80 then return "HOT" end
    if pct >= 0.60 then return "ELEVATED" end
    return "NORMAL"
end

function Rt.volatilityStopAdjustment(pct)
    if Cfg.UseVolatilityStopWidening == false then return 1.0 end
    pct = clamp(tonumber(pct) or Rt.volatilityPercentile(), 0, 1)
    local startPct = clamp(tonumber(Cfg.VolWidenStartPct) or 0.75, 0, 0.99)
    local fullPct = clamp(tonumber(Cfg.VolWidenFullPct) or 1.0, startPct + 0.0001, 1.0)
    local t = clamp((pct - startPct) / max(fullPct - startPct, 0.0001), 0, 1)
    return 1.0 + t * max(tonumber(Cfg.VolWidenMax) or 0.25, 0)
end

function Rt.volatilityRiskMultiplier(pct)
    pct = clamp(tonumber(pct) or Rt.volatilityPercentile(), 0, 1)
    local function interp(x, x0, x1, y0, y1)
        if x1 <= x0 then return y1 end
        local t = clamp((x - x0) / (x1 - x0), 0, 1)
        return y0 + (y1 - y0) * t
    end
    local p25 = clamp(tonumber(Cfg.VolRiskP25) or 0.85, 0.10, 1.00)
    local p50 = clamp(tonumber(Cfg.VolRiskP50) or 1.00, 0.10, 1.00)
    local p60 = clamp(tonumber(Cfg.VolRiskP60) or 0.95, 0.10, 1.00)
    local p70 = clamp(tonumber(Cfg.VolRiskP70) or 0.90, 0.10, 1.00)
    local p80 = clamp(tonumber(Cfg.VolRiskP80) or 0.82, 0.10, 1.00)
    local p90 = clamp(tonumber(Cfg.VolRiskP90) or 0.75, 0.10, 1.00)
    local p100 = clamp(tonumber(Cfg.VolRiskP100) or 0.70, 0.10, 1.00)
    if pct <= 0.25 then return p25 end
    if pct <= 0.50 then return interp(pct, 0.25, 0.50, p25, p50) end
    if pct <= 0.60 then return interp(pct, 0.50, 0.60, p50, p60) end
    if pct <= 0.70 then return interp(pct, 0.60, 0.70, p60, p70) end
    if pct <= 0.80 then return interp(pct, 0.70, 0.80, p70, p80) end
    if pct <= 0.90 then return interp(pct, 0.80, 0.90, p80, p90) end
    return interp(pct, 0.90, 1.00, p90, p100)
end

local function vwapCrossCount(p, n)
    local first = p - n + 1
    if first < Rt.Source:first() + 1 then return 0 end
    local c = 0
    for i = first, p do
        if Ind.vwap[i] ~= nil and Ind.vwap[i - 1] ~= nil then
            local a = Rt.Source.close[i - 1] - Ind.vwap[i - 1]
            local b = Rt.Source.close[i] - Ind.vwap[i]
            if a * b < 0 then c = c + 1 end
        end
    end
    return c
end

local function alternatingCandles(p, n)
    local first = p - n + 1
    if first < Rt.Source:first() + 1 then return 0 end
    local flips, total = 0, 0
    local prevDir = 0
    for i = first, p do
        local d = Rt.Source.close[i] > Rt.Source.open[i] and 1 or (Rt.Source.close[i] < Rt.Source.open[i] and -1 or 0)
        if d ~= 0 then
            if prevDir ~= 0 then total = total + 1; if d ~= prevDir then flips = flips + 1 end end
            prevDir = d
        end
    end
    return total > 0 and flips / total or 0
end

local function appendStructureEvent(state, label, value, period)
    state.events[#state.events + 1] = {label=label, value=value, period=period}
    while #state.events > 6 do table.remove(state.events, 1) end
end

-- Deterministic structure replay: each historical bar uses only data available
-- at that bar. Normal operation processes one step; startup replays loaded history.
function Rt.structureStep(state, p)
    local strength, source = Cfg.StructurePivotStrength, Rt.Source
    local candidate = p-strength
    local atrNow = Ind.atr[p]
    state.bosUp, state.bosDown, state.choch = false, false, false
    state.chochDirection = "NONE"
    state.appliedSide, state.appliedWeight = "NONE", 0
    state.filterDataMissing = false
    if candidate >= source:first()+strength then
        local hi, lo = source.high[candidate], source.low[candidate]
        local ph, pl = validNumber(hi), validNumber(lo)
        for i=candidate-strength,candidate+strength do
            if i~=candidate then
                if ph and (not validNumber(source.high[i]) or source.high[i]>=hi) then ph=false end
                if pl and (not validNumber(source.low[i]) or source.low[i]<=lo) then pl=false end
            end
        end
        -- Outside candles have no known high/low ordering. Record ambiguity,
        -- not an invented pair. Require a subsequent unambiguous high AND low.
        if ph and pl then
            state.ambiguousAt=candidate
            appendStructureEvent(state,"DUAL",nil,candidate)
        else
            local minSize=Cfg.StructureMinPivotATR or 0
            -- p is this candidate's confirmation bar, even during a replay.
            if minSize>0 then
                if not validNumber(atrNow) or atrNow<=0 then
                    state.filterDataMissing=ph or pl; ph,pl=false,false
                else
                    if ph and state.lastHigh and abs(hi-state.lastHigh.value)<minSize*atrNow then ph=false end
                    if pl and state.lastLow and abs(lo-state.lastLow.value)<minSize*atrNow then pl=false end
                end
            end
            if ph then
                local label="H?"
                if state.lastHigh then label=hi>state.lastHigh.value and "HH" or (hi<state.lastHigh.value and "LH" or "EH") end
                state.previousHigh=state.lastHigh
                state.lastHigh={value=hi,period=candidate,confirmedAt=p,label=label,id="H:"..tostring(candidate),breakSeen=false}
                appendStructureEvent(state,label,hi,candidate)
            end
            if pl then
                local label="L?"
                if state.lastLow then label=lo>state.lastLow.value and "HL" or (lo<state.lastLow.value and "LL" or "EL") end
                state.previousLow=state.lastLow
                state.lastLow={value=lo,period=candidate,confirmedAt=p,label=label,id="L:"..tostring(candidate),breakSeen=false}
                appendStructureEvent(state,label,lo,candidate)
            end
        end
        state.lastCandidate=candidate
    end
    local h,l=state.lastHigh,state.lastLow
    local ageLimit=Cfg.StructureMaxPivotAgeBars
    state.highAge=h and p-h.period or nil
    state.lowAge=l and p-l.period or nil
    state.highStale=h==nil or state.highAge>ageLimit
    state.lowStale=l==nil or state.lowAge>ageLimit
    state.stale=state.highStale or state.lowStale
    state.ambiguous=state.ambiguousAt~=nil and (h==nil or l==nil
        or h.period<=state.ambiguousAt or l.period<=state.ambiguousAt)
    state.rawBias="TRANSITION"
    if h and l then
        if h.label=="HH" and l.label=="HL" then state.rawBias="BULLISH"
        elseif h.label=="LH" and l.label=="LL" then state.rawBias="BEARISH" end
    end
    local n=#state.events
    local labels={}
    for i=max(1,n-2),n do labels[#labels+1]=state.events[i].label end
    state.sequence=n>0 and table.concat(labels,">") or "NA"
    local close,previous=source.close[p],p>source:first() and source.close[p-1] or nil
    local pricesOK=validNumber(close) and validNumber(previous)
    local usable=not state.stale and not state.ambiguous and not state.filterDataMissing and pricesOK
    local thesis=state.thesis
    if thesis and (p-thesis.high.period>ageLimit or p-thesis.low.period>ageLimit) then
        state.thesis=nil;thesis=nil
    end
    -- Break against the previously established thesis before accepting new
    -- labels; a new pivot cannot erase an adverse break on this same candle.
    if usable and thesis and not state.broken then
        local bullish=thesis.bias=="BULLISH"
        local support=bullish and thesis.low or thesis.high
        local adverse=bullish and close<support.value or (not bullish and close>support.value)
        if adverse then
            state.broken={bias=thesis.bias,level=support.value,pivotId=support.id,
                brokenAt=p,recoveryCloses=0}
            local crossing=bullish and previous>=support.value or (not bullish and previous<=support.value)
            if crossing and not support.breakSeen then
                support.breakSeen=true
                state.choch=true;state.chochDirection=bullish and "DOWN" or "UP"
            end
        else
            local boundary=bullish and thesis.high or thesis.low
            local crossing=bullish and previous<=boundary.value and close>boundary.value
                or (not bullish and previous>=boundary.value and close<boundary.value)
            if crossing and not boundary.breakSeen then
                boundary.breakSeen=true;state.bosUp=bullish;state.bosDown=not bullish
            end
        end
    end
    -- Recovery rule: TWO consecutive closes back on the original thesis side
    -- of the broken level, with fresh matching structure; alternatively both
    -- pivots formed after the break can establish a fresh directional thesis.
    if state.broken and p>state.broken.brokenAt then
        local broken=state.broken
        local recovered=usable and state.rawBias==broken.bias
            and ((broken.bias=="BULLISH" and close>broken.level)
                or (broken.bias=="BEARISH" and close<broken.level))
        broken.recoveryCloses=recovered and broken.recoveryCloses+1 or 0
        local newStructure=usable and h.period>broken.brokenAt and l.period>broken.brokenAt
            and (state.rawBias=="BULLISH" or state.rawBias=="BEARISH")
            and ((state.rawBias=="BULLISH" and close>=l.value)
                or (state.rawBias=="BEARISH" and close<=h.value))
        if broken.recoveryCloses>=2 or newStructure then
            state.broken=nil;state.thesis=nil
        end
    end
    if h==nil or l==nil then state.bias="UNAVAILABLE"
    elseif state.stale then state.bias="STALE"
    elseif state.ambiguous then state.bias="AMBIGUOUS"
    elseif not pricesOK or state.filterDataMissing then state.bias="UNAVAILABLE"
    elseif state.broken then state.bias="BROKEN"
    else state.bias=state.rawBias end
    if usable and not state.broken and (state.bias=="BULLISH" or state.bias=="BEARISH") then
        -- Do not initialize a directional thesis already beyond its own support.
        local intact=state.bias=="BULLISH" and close>=l.value or state.bias=="BEARISH" and close<=h.value
        if intact then state.thesis={bias=state.bias,high=h,low=l}
        else
            state.broken={bias=state.bias,level=state.bias=="BULLISH" and l.value or h.value,
                pivotId=state.bias=="BULLISH" and l.id or h.id,brokenAt=p,recoveryCloses=0}
            state.bias="BROKEN"
        end
    end
    local quality,phase,swingRange=40,"TRANSITION",0
    if h and l and validNumber(atrNow) and atrNow>0 then
        swingRange=abs(h.value-l.value)/atrNow
        if swingRange>=1.5 then quality=quality+15 elseif swingRange>=.8 then quality=quality+8 end
    end
    local directional=state.bias=="BULLISH" or state.bias=="BEARISH"
    if directional then quality=quality+30 end
    if state.bosUp or state.bosDown then
        quality=quality+12;phase=state.bosUp and "BOS_UP" or "BOS_DOWN"
    elseif state.choch then
        quality=quality+8;phase=state.chochDirection=="UP" and "CHOCH_UP" or "CHOCH_DOWN"
    elseif directional and h and l then
        local upper=close>=.5*(h.value+l.value)
        phase=state.bias=="BULLISH" and (upper and "IMPULSE_UP" or "PULLBACK_UP")
            or (upper and "PULLBACK_DOWN" or "IMPULSE_DOWN")
        quality=quality+5
    end
    if state.bias=="UNAVAILABLE" then quality=0;phase="UNAVAILABLE"
    elseif state.stale then quality=min(quality,30);phase="STALE"
    elseif state.ambiguous then quality=min(quality,25);phase="AMBIGUOUS"
    elseif state.broken then quality=min(quality,35);if not state.choch then phase="BROKEN" end end
    state.quality=clamp(quality,0,100);state.phase=phase;state.swingRangeATR=swingRange
    local conf=state.quality
    if directional then
        local age=max(state.highAge,state.lowAge)
        if age<=10 then conf=conf+5 elseif age>ageLimit*.7 then conf=conf-10 end
    end
    state.confidence=clamp(conf,0,100)
    state.lastProcessed=p
end

local function updateConfirmedMarketStructure(p)
    if Rt.Source==nil or Cfg.StructurePivotStrength==nil then return end
    local first=Rt.Source:first()
    local state=Rt.marketStructure
    if state==nil or state.sourceFirst~=first or state.lastProcessed==nil or p<state.lastProcessed then
        state={events={},sourceFirst=first,lastProcessed=first-1}
        Rt.marketStructure=state
    end
    for bar=state.lastProcessed+1,p do Rt.structureStep(state,bar) end
end

function Rt.structureSummary()
    local st=Rt.marketStructure or {}
    if st.broken then
        return string.format("%s thesis broken %s %.5f; recovery needs two closes back across it with fresh matching structure, or a new confirmed structure.",
            st.broken.bias=="BULLISH" and "Bullish" or "Bearish",
            st.broken.bias=="BULLISH" and "below" or "above",st.broken.level)
    end
    if st.ambiguous then return "Ambiguous outside-candle pivots; waiting for a new confirmed high and low." end
    if st.stale then return "Confirmed pivots missing or stale; old labels cannot confirm direction." end
    return tostring(st.bias or "UNAVAILABLE") .. "; " .. tostring(st.sequence or "NA")
        .. (st.choch and ("; CHOCH "..st.chochDirection) or (st.bosUp and "; new BOS UP" or (st.bosDown and "; new BOS DOWN" or "")))
end

-- =========================
-- Key Levels: Asian H/L, prior-day H/L, London opening range
-- =========================
-- Incremental UTC-day / session range tracking for breakout and false-breakout
-- geometry. Levels freeze when their window ends and stay valid for the
-- following London day. Fail soft: missing levels simply disable key-level paths.
local KeyLevels = {}

local function keyLevelsUtcParts(barDate)
    if barDate == nil then return nil end
    local okUTC, utcDate = pcall(function()
        return core.host:execute("convertTime", core.TZ_EST, core.TZ_UTC, barDate)
    end)
    if not okUTC or not validNumber(utcDate) then return nil end
    local okTable, t = pcall(function() return core.dateToTable(utcDate) end)
    if not okTable or type(t) ~= "table" or t.year == nil then return nil end
    local clock = utcDate - math.floor(utcDate)
    local dayKey = string.format("%04d-%02d-%02d", t.year, t.month, t.day)
    return {
        utcDate = utcDate,
        clock = clock,
        dayKey = dayKey,
        year = t.year, month = t.month, day = t.day,
        hour = t.hour or 0, min = t.min or 0,
    }
end

local function keyLevelsInAsianWindow(clock)
    local openT = Rt.AsianRangeOpen
    local closeT = Rt.AsianRangeClose
    if openT == nil or closeT == nil or clock == nil then return false end
    return sessionWindowActive(clock, openT, closeT)
end

local function keyLevelsLondonOrActive(clock)
    local londonOpen = Rt.LondonOpen
    if londonOpen == nil or clock == nil then return false end
    local minutes = tonumber(Cfg.LondonORMinutes) or 30
    if minutes < 5 then minutes = 5 end
    if minutes > 120 then minutes = 120 end
    local clockSeconds = math.floor(clock * 86400 + 0.5) % 86400
    local openSeconds = math.floor(londonOpen * 86400 + 0.5) % 86400
    return (clockSeconds - openSeconds) % 86400 < minutes * 60
end

function KeyLevels.step(p)
    if not Cfg.UseKeyLevels then
        Context.keyLevels = {enabled=false, text="key levels off"}
        return
    end
    if Rt.keyLevels == nil then
        Rt.keyLevels = {
            asianHigh=nil, asianLow=nil, asianReady=false, asianKey=nil,
            buildAsianHigh=nil, buildAsianLow=nil, buildAsianKey=nil,
            dayHigh=nil, dayLow=nil, dayKey=nil,
            prevDayHigh=nil, prevDayLow=nil, prevDayReady=false,
            orHigh=nil, orLow=nil, orReady=false, orDayKey=nil, orBars=0,
            lastBarSerial=nil,
        }
    end
    local kl = Rt.keyLevels
    local barDate = Rt.Source ~= nil and Rt.Source:date(p) or nil
    local parts = keyLevelsUtcParts(barDate)
    local high = Rt.Source.high[p]
    local low = Rt.Source.low[p]
    if parts == nil or not validNumber(high) or not validNumber(low) then
        Context.keyLevels = {enabled=true, ready=false, text="key levels time/price unavailable"}
        return
    end

    local barMinutes = timeframeMinutes(Cfg.TF)
    local asianMinutes = ((Rt.AsianRangeClose - Rt.AsianRangeOpen) % 1) * 1440
    local orKey = parts.dayKey
    local clockSeconds = math.floor(parts.clock * 86400 + 0.5) % 86400
    local londonSeconds = math.floor(Rt.LondonOpen * 86400 + 0.5) % 86400
    if londonSeconds + Cfg.LondonORMinutes * 60 > 86400 and clockSeconds < londonSeconds then
        local previous = core.dateToTable(parts.utcDate - 1)
        orKey = string.format("%04d-%02d-%02d", previous.year, previous.month, previous.day)
    end
    if kl.orDayKey ~= orKey then
        kl.orHigh, kl.orLow, kl.orReady, kl.orBars = nil, nil, false, 0
        kl.orComplete, kl.orLastDate, kl.orDayKey = false, nil, orKey
    end

    -- --- Previous UTC calendar day high/low ---
    if kl.dayKey == nil then
        kl.dayKey = parts.dayKey
        kl.dayComplete = parts.clock < 1.0 / 86400.0
        kl.dayHigh = high
        kl.dayLow = low
    elseif parts.dayKey ~= kl.dayKey then
        if validNumber(kl.dayHigh) and validNumber(kl.dayLow) then
            kl.prevDayHigh = kl.dayHigh
            kl.prevDayLow = kl.dayLow
            kl.prevDayReady = kl.dayComplete == true and kl.prevDayHigh > kl.prevDayLow
        end
        kl.dayKey = parts.dayKey
        kl.dayComplete = true
        kl.dayHigh = high
        kl.dayLow = low
    else
        if high > (kl.dayHigh or high) then kl.dayHigh = high end
        if low < (kl.dayLow or low) then kl.dayLow = low end
    end

    -- --- Asian range (configurable UTC window, typically 00:00-07:00) ---
    local inAsian = keyLevelsInAsianWindow(parts.clock)
    local asianKey = parts.dayKey
    -- A cross-midnight window has ONE identity: its UTC end date.
    if Rt.AsianRangeOpen ~= nil and Rt.AsianRangeClose ~= nil
        and Rt.AsianRangeOpen > Rt.AsianRangeClose
        and clockSeconds >= math.floor(Rt.AsianRangeOpen * 86400 + 0.5) then
        local endDay = core.dateToTable(parts.utcDate + 1)
        asianKey = string.format("%04d-%02d-%02d", endDay.year, endDay.month, endDay.day)
    end
    if inAsian then
        if kl.buildAsianKey ~= asianKey then
            -- Starting a new Asian build; freeze prior build if any
            if kl.buildAsianKey ~= nil and validNumber(kl.buildAsianHigh)
                and validNumber(kl.buildAsianLow)
                and kl.buildAsianHigh > kl.buildAsianLow then
                kl.asianHigh = kl.buildAsianHigh
                kl.asianLow = kl.buildAsianLow
                kl.asianKey = kl.buildAsianKey
                kl.asianReady = kl.buildAsianComplete == true and barMinutes ~= nil
                and (kl.buildAsianBars or 0) * barMinutes >= asianMinutes - 1e-6
            end
            kl.asianReady = false
            kl.buildAsianComplete = abs(parts.clock - Rt.AsianRangeOpen) < 1.0 / 86400.0
            kl.buildAsianKey = asianKey
            kl.buildAsianHigh = high
            kl.buildAsianLow = low
            kl.buildAsianBars = 1
        else
            kl.buildAsianBars = (kl.buildAsianBars or 0) + 1
            if barMinutes == nil or kl.buildAsianLastDate == nil
                or abs((barDate - kl.buildAsianLastDate) * 1440 - barMinutes) > 1.0 / 60.0 then
                kl.buildAsianComplete = false
            end
            if high > (kl.buildAsianHigh or high) then kl.buildAsianHigh = high end
            if low < (kl.buildAsianLow or low) then kl.buildAsianLow = low end
        end
        kl.buildAsianLastDate = barDate
    else
        -- Left Asian window: freeze completed Asian range for London use
        if kl.buildAsianKey ~= nil and validNumber(kl.buildAsianHigh)
            and validNumber(kl.buildAsianLow)
            and kl.buildAsianHigh > kl.buildAsianLow then
            kl.asianHigh = kl.buildAsianHigh
            kl.asianLow = kl.buildAsianLow
            kl.asianKey = kl.buildAsianKey
            kl.asianReady = kl.buildAsianComplete == true and barMinutes ~= nil
                and (kl.buildAsianBars or 0) * barMinutes >= asianMinutes - 1e-6
            kl.buildAsianKey = nil
            kl.buildAsianHigh = nil
            kl.buildAsianLow = nil
        end
    end

    -- --- London opening range (first N minutes after London open UTC) ---
    if keyLevelsLondonOrActive(parts.clock) then
        if kl.orDayKey ~= orKey or kl.orHigh == nil or kl.orLow == nil then
            kl.orDayKey = orKey
            kl.orHigh, kl.orLow, kl.orBars, kl.orReady = high, low, 1, false
            kl.orComplete = abs(parts.clock - Rt.LondonOpen) < 1.0 / 86400.0
        else
            if high > (kl.orHigh or high) then kl.orHigh = high end
            if low < (kl.orLow or low) then kl.orLow = low end
            kl.orBars = (kl.orBars or 0) + 1
            local minutes = timeframeMinutes(Cfg.TF)
            if minutes == nil or kl.orLastDate == nil
                or abs((barDate - kl.orLastDate) * 1440 - minutes) > 1.0 / 60.0 then
                kl.orComplete = false
            end
        end
        kl.orLastDate = barDate
    else
        -- After OR window ends, mark ready if we collected range
        if kl.orDayKey == orKey and validNumber(kl.orHigh) and validNumber(kl.orLow)
            and kl.orHigh > kl.orLow and not kl.orReady then
            local minutes = timeframeMinutes(Cfg.TF)
            kl.orReady = kl.orComplete == true and minutes ~= nil
                and (kl.orBars or 0) * minutes >= Cfg.LondonORMinutes
        end
    end

    Context.keyLevels = {
        enabled = true,
        asianHigh = kl.asianHigh, asianLow = kl.asianLow, asianReady = kl.asianReady == true,
        prevDayHigh = kl.prevDayHigh, prevDayLow = kl.prevDayLow, prevDayReady = kl.prevDayReady == true,
        orHigh = kl.orHigh, orLow = kl.orLow, orReady = kl.orReady == true, orBars = kl.orBars or 0,
        inAsian = inAsian,
        inOR = keyLevelsLondonOrActive(parts.clock),
        dayKey = parts.dayKey,
        text = string.format(
            "ASIA %s PD %s OR %s",
            kl.asianReady and string.format("%.1f/%.1f", kl.asianHigh or 0, kl.asianLow or 0) or "n/a",
            kl.prevDayReady and string.format("%.1f/%.1f", kl.prevDayHigh or 0, kl.prevDayLow or 0) or "n/a",
            (kl.orReady or (kl.orBars or 0) > 0) and string.format("%.1f/%.1f%s", kl.orHigh or 0, kl.orLow or 0, kl.orReady and "" or "*") or "n/a"),
    }
end

-- Replay loaded CLOSED history on startup and missed callbacks. Never build
-- a previous day or session range using only the last callback's candle.
function KeyLevels.update(p)
    if not Cfg.UseKeyLevels then
        Context.keyLevels = {enabled=false, text="key levels off"}
        return
    end
    local first = Rt.Source:first()
    if Rt.keySourceFirst ~= first or Rt.keyLastPeriod == nil or p < Rt.keyLastPeriod then
        Rt.keyLevels, Rt.keyLastPeriod, Rt.keySourceFirst = nil, first - 1, first
    end
    for i = Rt.keyLastPeriod + 1, p do KeyLevels.step(i) end
    Rt.keyLastPeriod = p
end

local function keyLevelBuffer(atr)
    local buf = (Cfg.KeyLevelBufferATR or 0.05) * (atr or 0)
    if buf < 0 then buf = 0 end
    return buf
end

-- True breakout: close beyond level by BreakoutATRMin * ATR, with side momentum.
function KeyLevels.computeBreakoutStatus(side)
    if not Cfg.UseKeyLevels or not Cfg.UseKeyLevelBreakout then
        return false, "key-level breakout off"
    end
    local c = Context
    local kl = Context.keyLevels
    if type(kl) ~= "table" or not kl.enabled then
        return false, "key levels unavailable"
    end
    if not validNumber(c.close) or not validNumber(c.atr) or c.atr <= 0 then
        return false, "key-level breakout data missing"
    end
    local minBeyond = (Cfg.BreakoutATRMin or 0.10) * c.atr
    local buf = keyLevelBuffer(c.atr)
    local hits = {}
    local function tryLevel(name, level, ready)
        if not ready or not validNumber(level) then return end
        if side == "B" then
            if c.close > level + minBeyond then
                hits[#hits + 1] = string.format("%s↑%.1f", name, level)
            end
        else
            if c.close < level - minBeyond then
                hits[#hits + 1] = string.format("%s↓%.1f", name, level)
            end
        end
    end
    tryLevel("ASIA", side == "B" and kl.asianHigh or kl.asianLow, kl.asianReady)
    tryLevel("PD", side == "B" and kl.prevDayHigh or kl.prevDayLow, kl.prevDayReady)
    -- OR breakout only after OR is complete (not while still building)
    tryLevel("OR", side == "B" and kl.orHigh or kl.orLow, kl.orReady)

    if #hits == 0 then
        return false, "no key-level break"
    end
    local momOK = side == "B" and (c.momentumATR or 0) > 0.25
        or side == "S" and (c.momentumATR or 0) < -0.25
    local candleOK = side == "B" and c.close > c.open or side == "S" and c.close < c.open
    local extensionOK = side == "B"
        and (c.vwapDistATR or 0) <= (Cfg.BreakoutMaxExtensionATR or 4.0)
        or side == "S" and (c.vwapDistATR or 0) >= -(Cfg.BreakoutMaxExtensionATR or 4.0)
    local ok = momOK and candleOK and extensionOK
    return ok, string.format(
        "KEY_BREAK_%s levels=[%s] mom=%s candle=%s ext=%s",
        side == "B" and "LONG" or "SHORT", table.concat(hits, ","),
        yn(momOK), yn(candleOK), yn(extensionOK))
end

-- False breakout: trade pierces level then closes back inside with rejection.
function KeyLevels.computeFalseBreakoutStatus(side)
    if not Cfg.UseKeyLevels or not Cfg.UseKeyLevelFalseBreakout then
        return false, "key-level false-breakout off"
    end
    local c = Context
    local kl = Context.keyLevels
    if type(kl) ~= "table" or not kl.enabled then
        return false, "key levels unavailable"
    end
    if not validNumber(c.high) or not validNumber(c.low) or not validNumber(c.close)
        or not validNumber(c.atr) or c.atr <= 0 then
        return false, "false-breakout data missing"
    end
    local minPierce = (Cfg.KeyLevelFalseBreakPierceATR or 0.10) * c.atr
    local hits = {}
    local function tryLevel(name, level, ready)
        if not ready or not validNumber(level) then return end
        if side == "B" then
            -- Bullish false break: swept below support, closed back above
            if c.low < level - minPierce and c.close > level then
                hits[#hits + 1] = string.format("%s_sweep↓%.1f", name, level)
            end
        else
            -- Bearish false break: swept above resistance, closed back below
            if c.high > level + minPierce and c.close < level then
                hits[#hits + 1] = string.format("%s_sweep↑%.1f", name, level)
            end
        end
    end
    tryLevel("ASIA", side == "B" and kl.asianLow or kl.asianHigh, kl.asianReady)
    tryLevel("PD", side == "B" and kl.prevDayLow or kl.prevDayHigh, kl.prevDayReady)
    tryLevel("OR", side == "B" and kl.orLow or kl.orHigh, kl.orReady)

    if #hits == 0 then
        return false, "no key-level false-break"
    end
    local rejectOK = side == "B" and c.rejectionBull or side == "S" and c.rejectionBear
    if Cfg.KeyLevelFalseBreakRequireRejection and not rejectOK then
        return false, string.format("KEY_FB_%s levels=[%s] but rejection missing",
            side == "B" and "LONG" or "SHORT", table.concat(hits, ","))
    end
    local rsi = tonumber(c.rsi) or 50
    local rsiOK = side == "B" and rsi <= (Cfg.KeyLevelFalseBreakRSIMax or 55)
        or side == "S" and rsi >= (Cfg.KeyLevelFalseBreakRSIMin or 45)
    local ok = rsiOK
    return ok, string.format(
        "KEY_FB_%s levels=[%s] rej=%s RSI=%.0f=%s",
        side == "B" and "LONG" or "SHORT", table.concat(hits, ","),
        yn(rejectOK), rsi, yn(rsiOK))
end


-- All callers (classification, candidate nomination, scoring and geometry)
-- share the same key-level evidence for this completed candle.
function KeyLevels.cachedStatus(kind, side)
    Rt.keyStatusCache = Rt.keyStatusCache or {}
    local key = kind .. side
    local result = Rt.keyStatusCache[key]
    if result == nil then
        local ok, description
        if kind == "BREAK" then ok, description = KeyLevels.computeBreakoutStatus(side)
        else ok, description = KeyLevels.computeFalseBreakoutStatus(side) end
        result = {ok=ok, description=description}
        Rt.keyStatusCache[key] = result
    end
    return result.ok, result.description
end

function KeyLevels.breakoutStatus(side)
    return KeyLevels.cachedStatus("BREAK", side)
end

function KeyLevels.falseBreakoutStatus(side)
    return KeyLevels.cachedStatus("FALSE", side)
end

function Rt.breakoutPresent(side)
    if side == "B" then return Context.breakHigh or KeyLevels.breakoutStatus(side) end
    return Context.breakLow or KeyLevels.breakoutStatus(side)
end

local function updateMarketContext(p)
    Rt.pullbackCache = nil
    Rt.keyStatusCache = nil
    Rt.fastTouchCache = nil
    updateConfirmedMarketStructure(p)
    Context = {}
    Context.p = p
    Context.close = Rt.Source.close[p]
    Context.open = Rt.Source.open[p]
    Context.high = Rt.Source.high[p]
    Context.low = Rt.Source.low[p]
    Context.atr = Ind.atr[p]
    Context.rsi = Ind.rsi[p]
    Context.adx = Ind.adx[p]
    Context.emaFast = Ind.emaFast[p]
    Context.emaMed = Ind.emaMed[p]
    Context.emaSlow = Ind.emaSlow[p]
    Context.vwap = Ind.vwap[p]
    Context.swingHigh = Ind.swingHigh[p]
    Context.swingLow = Ind.swingLow[p]
    Context.marketStructureBias = Rt.marketStructure.bias
    Context.marketStructureRawBias = Rt.marketStructure.rawBias
    Context.marketStructureSequence = Rt.marketStructure.sequence
    Context.marketStructureLastHigh = Rt.marketStructure.lastHigh
    Context.marketStructureLastLow = Rt.marketStructure.lastLow
    Context.marketStructureBOSUp = Rt.marketStructure.bosUp
    Context.marketStructureBOSDown = Rt.marketStructure.bosDown
    Context.marketStructureCHOCH = Rt.marketStructure.choch
    Context.marketStructureCHOCHDirection = Rt.marketStructure.chochDirection
    Context.marketStructureHighAge = Rt.marketStructure.highAge
    Context.marketStructureLowAge = Rt.marketStructure.lowAge
    Context.marketStructureStale = Rt.marketStructure.stale
    Context.marketStructurePhase = Rt.marketStructure.phase
    Context.marketStructureQuality = Rt.marketStructure.quality
    Context.marketStructureConfidence = Rt.marketStructure.confidence
    Context.marketStructureSwingRangeATR = Rt.marketStructure.swingRangeATR
    Context.rangePosition = 0.5
    if validNumber(Context.swingHigh) and validNumber(Context.swingLow)
        and Context.swingHigh > Context.swingLow then
        Context.rangePosition = clamp(safeDiv(Context.close - Context.swingLow,
            Context.swingHigh - Context.swingLow, 0.5), 0, 1)
    end
    Context.efficiency = Ind.efficiency[p] or 0
    Context.atrPct = percentileArray(Ind.atr, p, Cfg.StatsPeriod, Ind.atr[p])
    Context.volatilityAtrPct = percentileArray(Ind.atr, p, Cfg.VolatilityLookback, Ind.atr[p])
    Context.adxPct = percentileArray(Ind.adx, p, Cfg.StatsPeriod, Ind.adx[p])
    Context.bbPct = Ind.bbWidth[p] and percentileArray(Ind.bbWidth, p, Cfg.StatsPeriod, Ind.bbWidth[p]) or 0.5
    Context.vwapDistATR = safeDiv(Context.close - Context.vwap, Context.atr, 0)
    Context.emaSeparationATR = safeDiv(max(Context.emaFast, max(Context.emaMed, Context.emaSlow)) - min(Context.emaFast, min(Context.emaMed, Context.emaSlow)), Context.atr, 0)
    Context.rangeATR = safeDiv(Context.high - Context.low, Context.atr, 0)
    Context.momentumATR = 0
    if p - Cfg.MomentumPeriod >= Rt.Source:first() then Context.momentumATR = safeDiv(Context.close - Rt.Source.close[p - Cfg.MomentumPeriod], Context.atr, 0) end
    Context.vwapCrosses = vwapCrossCount(p, min(20, Cfg.StatsPeriod))
    Context.alternation = alternatingCandles(p, min(12, Cfg.StatsPeriod))
    Context.plusDirection = Ind.plusDI[p] or 0
    Context.minusDirection = Ind.minusDI[p] or 0
    Context.emaFastSlope = Ind.emaFast[p] - (Ind.emaFast[p - 3] or Ind.emaFast[p])
    Context.emaMedSlope = Ind.emaMed[p] - (Ind.emaMed[p - 3] or Ind.emaMed[p])
    Context.bandExpanding = Ind.bbWidth[p] ~= nil and Ind.bbWidth[p - 3] ~= nil and Ind.bbWidth[p] > Ind.bbWidth[p - 3]
    Context.atrExpanding = Ind.atr[p - 3] ~= nil and Ind.atr[p] > Ind.atr[p - 3]
    Context.breakHigh = Context.swingHigh ~= nil and Context.close > Context.swingHigh + Cfg.BreakoutATRMin * Context.atr
    Context.breakLow = Context.swingLow ~= nil and Context.close < Context.swingLow - Cfg.BreakoutATRMin * Context.atr
    Context.priorATRPct = 0.5
    Context.priorBBPct = 0.5
    Context.compressionRangeATR = math.huge
    Context.consolidationOK = false
    local compressionFirst = p - Cfg.BreakoutCompressionLookback
    if compressionFirst >= Rt.Source:first()
        and Ind.atr[p - 1] ~= nil and Ind.bbWidth[p - 1] ~= nil then
        Context.priorATRPct = percentileArray(Ind.atr, p - 1, Cfg.StatsPeriod, Ind.atr[p - 1])
        Context.priorBBPct = percentileArray(Ind.bbWidth, p - 1, Cfg.StatsPeriod, Ind.bbWidth[p - 1])
        local priorHigh = rollingMax(Rt.Source.high, compressionFirst, p - 1)
        local priorLow = rollingMin(Rt.Source.low, compressionFirst, p - 1)
        -- Normalize the pre-breakout range by the PRIOR ATR, not the expanded
        -- breakout bar's ATR, so the breakout itself cannot make a loose prior
        -- range look artificially compressed.
        Context.compressionRangeATR = safeDiv(priorHigh - priorLow, Ind.atr[p - 1], math.huge)
        Context.consolidationOK = Context.compressionRangeATR <= Cfg.CompressionRangeATRMax
            and (Context.priorATRPct <= Cfg.CompressionATRPctMax
                or Context.priorBBPct <= Cfg.CompressionBBPctMax)
    end
    -- Volume is confirmatory only. Missing/unavailable tick volume (common on
    -- indices and some CFDs) must never hard-block an otherwise valid setup.
    Context.volumeOK = true
    Context.volumeConfirmed = false -- availability is separate from permission
    Context.volumeStatus = "off"
    if Cfg.UseVolumeFilter then
        local currentVolume = nil
        if Rt.Source.volume ~= nil then
            currentVolume = tonumber(Rt.Source.volume[p])
        end
        local avgVol = tonumber(Ind.avgVolume[p])
        if not validNumber(currentVolume) or not validNumber(avgVol) or avgVol <= 0 then
            -- Data unavailable: pass the gate; do not treat as a failed confirmation.
            Context.volumeOK = true
            Context.volumeStatus = "unavailable_skipped"
        elseif (currentVolume / avgVol) >= Cfg.VolumeFactor then
            Context.volumeOK = true
            Context.volumeConfirmed = true
            Context.volumeStatus = "confirmed"
        else
            Context.volumeOK = false
            Context.volumeStatus = string.format("low %.2fx<%.2f",
                currentVolume / avgVol, Cfg.VolumeFactor)
        end
    end
    Context.rejectionBull = (Context.close > Context.open) and ((Context.open - Context.low) > (Context.high - Context.close))
    Context.rejectionBear = (Context.close < Context.open) and ((Context.high - Context.open) > (Context.close - Context.low))
    KeyLevels.update(p)
end

-- =========================
-- Regime engine: each score 0..10
-- =========================
local function calculateRegimeScores()
    Scores = {trendUp=0, trendDown=0, range=0, breakout=0, reversalBull=0, reversalBear=0, highVol=0, lowVol=0}
    local c = Context

    -- Trend: structure (EMA), slope, ADX, VWAP, DMI/price momentum.
    if c.emaFast > c.emaMed and c.emaMed > c.emaSlow then Scores.trendUp = Scores.trendUp + 2.5 end
    if c.emaFast < c.emaMed and c.emaMed < c.emaSlow then Scores.trendDown = Scores.trendDown + 2.5 end
    if c.emaFastSlope > 0 and c.emaMedSlope > 0 then Scores.trendUp = Scores.trendUp + 1.5 end
    if c.emaFastSlope < 0 and c.emaMedSlope < 0 then Scores.trendDown = Scores.trendDown + 1.5 end
    -- Strong ADX confirms that a trend exists, but it must not be credited to
    -- BOTH directions equally - that only compresses the margin between
    -- trendUp/trendDown (making detectMarketRegime's RegimeConfidenceMargin
    -- check fail) precisely when ADX is most confidently signaling a trend.
    -- Award DMI points only once, and only to the side DMI actually favors
    -- when ADX confirms. v7.0.7 removed a stacked unconditional +1.5 that
    -- double-counted DI+/DI- up to +3.0. v7.0.8 restores a single stronger
    -- ADX-confirmed DMI weight (+2.0) so the trend core still tops at 10.0:
    -- EMA stack 2.5 + slopes 1.5 + ADX/DMI 2.0 + VWAP 1.5 + momentum 2.5 = 10.
    if c.adxPct >= 0.55 or c.adx >= 22 then
        if c.plusDirection > c.minusDirection then Scores.trendUp = Scores.trendUp + 2.0
        elseif c.minusDirection > c.plusDirection then Scores.trendDown = Scores.trendDown + 2.0 end
    end
    if c.close > c.vwap then Scores.trendUp = Scores.trendUp + 1.5
    elseif c.close < c.vwap then Scores.trendDown = Scores.trendDown + 1.5 end
    if c.momentumATR > 0.3 then Scores.trendUp = Scores.trendUp + 2.5 end
    if c.momentumATR < -0.3 then Scores.trendDown = Scores.trendDown + 2.5 end

    -- Preserve the unweighted directional evidence for existing position
    -- management. The structure weight is intentionally an entry/regime
    -- selection input and must not silently accelerate regime-flip exits.
    Scores.trendUpBase = Scores.trendUp
    Scores.trendDownBase = Scores.trendDown

    -- Confirmed pivot structure contributes only to the matching directional
    -- trend score. It cannot create a signal or bypass any downstream gate.
    -- HH+HL supports uptrend; LH+LL supports downtrend; mixed structure adds 0.
    Rt.marketStructure.appliedSide, Rt.marketStructure.appliedWeight = "NONE", 0
    if Cfg.UseStructureDirectionWeight and Cfg.StructureDirectionWeight > 0
        and not c.marketStructureCHOCH and not c.marketStructureStale then
        local w = Cfg.StructureDirectionWeight
        -- Scale weight by structure confidence when enhanced engine is on
        if Cfg.UseEnhancedStructure then
            local sc = tonumber(c.marketStructureConfidence) or tonumber(Rt.marketStructure.confidence) or 50
            w = w * clamp(sc / 70.0, 0.5, 1.35)
            if c.marketStructurePhase == "IMPULSE_UP" or c.marketStructurePhase == "IMPULSE_DOWN"
                or c.marketStructurePhase == "BOS_UP" or c.marketStructurePhase == "BOS_DOWN" then
                w = w * 1.15
            elseif c.marketStructurePhase == "PULLBACK_UP" or c.marketStructurePhase == "PULLBACK_DOWN" then
                w = w * 0.9
            end
        end
        if c.marketStructureBias == "BULLISH" then
            Scores.trendUp = Scores.trendUp + w
            Rt.marketStructure.appliedSide = "TU"
            Rt.marketStructure.appliedWeight = w
        elseif c.marketStructureBias == "BEARISH" then
            Scores.trendDown = Scores.trendDown + w
            Rt.marketStructure.appliedSide = "TD"
            Rt.marketStructure.appliedWeight = w
        end
    end

    -- Range/chop: low ADX, compression, VWAP crossings, low Ind.efficiency, candle alternation.
    if c.adxPct <= 0.4 or c.adx < 18 then Scores.range = Scores.range + 2.0 end
    if c.emaSeparationATR < 0.45 then Scores.range = Scores.range + 2.0 end
    if c.vwapCrosses >= 3 then Scores.range = Scores.range + 2.0 end
    if c.efficiency < 0.35 then Scores.range = Scores.range + 2.0 end
    if c.alternation > 0.55 then Scores.range = Scores.range + 2.0 end

    -- Breakout: compression must precede structure break/expansion. Volume can
    -- contribute only when the user enabled the filter and real data passed;
    -- disabled volume must never award a free confidence point.
    if c.breakHigh or c.breakLow then Scores.breakout = Scores.breakout + 2.5 end
    if c.consolidationOK then Scores.breakout = Scores.breakout + 2.0 end
    if c.atrExpanding and c.atrPct >= 0.6 then Scores.breakout = Scores.breakout + 1.5 end
    if c.bandExpanding and c.bbPct >= 0.55 then Scores.breakout = Scores.breakout + 1.5 end
    if abs(c.momentumATR) >= 0.8 then Scores.breakout = Scores.breakout + 1.0 end
    if abs(c.vwapDistATR) >= 0.75 then Scores.breakout = Scores.breakout + 0.5 end
    if Cfg.UseVolumeFilter and c.volumeConfirmed == true then Scores.breakout = Scores.breakout + 1.0 end
    -- Key-level proximity / break soft evidence (does not by itself force a trade).
    if Cfg.UseKeyLevels and type(Context.keyLevels) == "table" and Context.keyLevels.enabled then
        local kl = Context.keyLevels
        local atr = tonumber(c.atr) or 0
        local closePx = tonumber(c.close)
        if atr > 0 and validNumber(closePx) then
            local near = 0.35 * atr
            local function nearLevel(level, ready)
                return ready and validNumber(level) and abs(closePx - level) <= near
            end
            if nearLevel(kl.asianHigh, kl.asianReady) or nearLevel(kl.asianLow, kl.asianReady)
                or nearLevel(kl.prevDayHigh, kl.prevDayReady) or nearLevel(kl.prevDayLow, kl.prevDayReady)
                or nearLevel(kl.orHigh, kl.orReady) or nearLevel(kl.orLow, kl.orReady) then
                Scores.breakout = Scores.breakout + 1.0
                Scores.range = Scores.range + 0.5
            end
            local klBO, _ = KeyLevels.breakoutStatus("B")
            local klBO_S, _ = KeyLevels.breakoutStatus("S")
            if klBO or klBO_S then Scores.breakout = clamp(Scores.breakout + 2.0, 0, 10) end
            local klFB, _ = KeyLevels.falseBreakoutStatus("B")
            local klFB_S, _ = KeyLevels.falseBreakoutStatus("S")
            if klFB then Scores.reversalBull = clamp((Scores.reversalBull or 0) + 1.5, 0, 10) end
            if klFB_S then Scores.reversalBear = clamp((Scores.reversalBear or 0) + 1.5, 0, 10) end
        end
    end

    -- Reversal / exhaustion: stretch + RSI + rejection + momentum weakening against stretch.
    if c.vwapDistATR <= -Cfg.VWAPStretchATR then Scores.reversalBull = Scores.reversalBull + 2.5 end
    if c.vwapDistATR >= Cfg.VWAPStretchATR then Scores.reversalBear = Scores.reversalBear + 2.5 end
    -- VWAP fade module: boost reversal score only when stretch + RSI exhaustion align.
    if Cfg.UseVWAPFade then
        local minStretch = Cfg.VWAPFadeMinATR or 2.0
        if c.vwapDistATR <= -minStretch and (c.rsi or 50) <= (Cfg.VWAPFadeRSILow or 30) then
            Scores.reversalBull = clamp((Scores.reversalBull or 0) + 4.0, 0, 10)
            if c.rejectionBull then Scores.reversalBull = clamp(Scores.reversalBull + 1.5, 0, 10) end
        end
        if c.vwapDistATR >= minStretch and (c.rsi or 50) >= (Cfg.VWAPFadeRSIHigh or 70) then
            Scores.reversalBear = clamp((Scores.reversalBear or 0) + 4.0, 0, 10)
            if c.rejectionBear then Scores.reversalBear = clamp(Scores.reversalBear + 1.5, 0, 10) end
        end
    end
    if c.rsi <= 30 then Scores.reversalBull = Scores.reversalBull + 2.0 end
    if c.rsi >= 70 then Scores.reversalBear = Scores.reversalBear + 2.0 end
    if c.rejectionBull then Scores.reversalBull = Scores.reversalBull + 1.5 end
    if c.rejectionBear then Scores.reversalBear = Scores.reversalBear + 1.5 end
    if c.vwapDistATR < -0.8 and c.momentumATR > -0.2 then Scores.reversalBull = Scores.reversalBull + 1.5 end
    if c.vwapDistATR > 0.8 and c.momentumATR < 0.2 then Scores.reversalBear = Scores.reversalBear + 1.5 end
    if c.swingLow ~= nil and c.low <= c.swingLow and c.close > c.swingLow then Scores.reversalBull = Scores.reversalBull + 1.5 end
    if c.swingHigh ~= nil and c.high >= c.swingHigh and c.close < c.swingHigh then Scores.reversalBear = Scores.reversalBear + 1.5 end
    if c.adxPct < 0.45 then
        Scores.reversalBull = Scores.reversalBull + 1.0
        Scores.reversalBear = Scores.reversalBear + 1.0
    end

    -- Volatility states.
    Scores.highVol = clamp((c.atrPct - 0.5) * 12, 0, 6)
    Scores.highVol = clamp(Scores.highVol + (c.rangeATR > 1.5 and 2 or 0) + (c.bbPct > 0.75 and 2 or 0), 0, 10)
    Scores.lowVol = clamp((0.5 - c.atrPct) * 12, 0, 6)
    Scores.lowVol = clamp(Scores.lowVol + (c.bbPct < 0.3 and 2 or 0) + (c.rangeATR < 0.8 and 2 or 0), 0, 10)

    for k,v in pairs(Scores) do Scores[k] = clamp(v, 0, 10) end
    Rt.regimeWeightAudit = nil
    if Cfg.WriteCSVLogFile then
        local names = {"trendUp", "trendDown", "range", "breakout", "reversalBull", "reversalBear", "highVol", "lowVol"}
        local fields = {}
        for i = 1, #names do
            local name = names[i]
            fields[#fields + 1] = string.format("%s=%.3f;at_cap=%s", name, Scores[name], yn(Scores[name] >= 10))
        end
        fields[#fields + 1] = "volume_confirmed=" .. yn(c.volumeConfirmed)
        Rt.regimeWeightAudit = table.concat(fields, "|")
    end
end

local function trendBreakoutDirection(regime)
    if regime == "TRENDING_UP" or regime == "BREAKOUT_UP" then return "B" end
    if regime == "TRENDING_DOWN" or regime == "BREAKOUT_DOWN" then return "S" end
    return nil
end

local function compatibleTrendBreakout(a, b)
    local direction = trendBreakoutDirection(a)
    if direction == nil or trendBreakoutDirection(b) ~= direction then return false, nil end
    local aTrend = string.sub(a, 1, 8) == "TRENDING"
    local bTrend = string.sub(b, 1, 8) == "TRENDING"
    local aBreakout = string.sub(a, 1, 8) == "BREAKOUT"
    local bBreakout = string.sub(b, 1, 8) == "BREAKOUT"
    return (aTrend and bBreakout) or (aBreakout and bTrend), direction
end

local function publishVolatilityOverride(name, score, priorBestName, priorBestScore)
    -- LOW/HIGH volatility are priority no-trade states, not members of the
    -- directional candidate race above. Publish a complete, internally
    -- consistent diagnostic result instead of retaining the prior candidate's
    -- runner-up and margin fields under the new volatility-state name.
    local candidateName = priorBestName ~= "NONE" and priorBestName or "NONE"
    local candidateScore = priorBestName ~= "NONE" and priorBestScore or 0
    -- The current regime may deliberately be a priority volatility state, but
    -- the published best/second ranking must remain mathematically ordered.
    -- This prevents diagnostics such as "best LOW_VOLATILITY 7.3, second
    -- TRENDING_UP 10.0, margin -2.7" while preserving the no-trade override.
    if candidateName ~= "NONE" and candidateScore > score then
        Rt.regimeBestName, Rt.regimeBestScore = candidateName, candidateScore
        Rt.regimeSecondName, Rt.regimeSecondScore = name, score
    else
        Rt.regimeBestName, Rt.regimeBestScore = name, score
        Rt.regimeSecondName, Rt.regimeSecondScore = candidateName, candidateScore
    end
    Rt.regimeCompetitorName, Rt.regimeCompetitorScore = Rt.regimeSecondName, Rt.regimeSecondScore
    Rt.regimeRawMargin = Rt.regimeBestScore - Rt.regimeSecondScore
    Rt.regimeEffectiveMargin = Rt.regimeRawMargin
    Rt.regimeConflict = false
    Rt.regimeCompatible = false
    Rt.regimeCompatibleSide = nil
    Rt.regimeCompatibilityText = nil
end

local function detectMarketRegime()
    local bestName = "NONE"
    local bestScore = -math.huge

    local candidates = {
        {"TRENDING_UP", Scores.trendUp, Cfg.RegimeThreshold},
        {"TRENDING_DOWN", Scores.trendDown, Cfg.RegimeThreshold},
        {"CHOPPY_RANGE", Scores.range, Cfg.RegimeThreshold},
        {"BREAKOUT_UP", Rt.breakoutPresent("B") and Scores.breakout or -math.huge, Cfg.RegimeThreshold},
        {"BREAKOUT_DOWN", Rt.breakoutPresent("S") and Scores.breakout or -math.huge, Cfg.RegimeThreshold},
        {"REVERSAL_BULL", Scores.reversalBull, Cfg.ReversalThreshold},
        {"REVERSAL_BEAR", Scores.reversalBear, Cfg.ReversalThreshold}
    }

    for _,x in ipairs(candidates) do
        -- A score exactly equal to its configured threshold qualifies.
        if x[2] >= x[3] and x[2] > bestScore then bestName = x[1]; bestScore = x[2] end
    end

    local secondName, secondScore = "NONE", -math.huge
    if bestName ~= "NONE" then
        for _,x in ipairs(candidates) do
            -- Only a regime that reached its own threshold may challenge the winner.
            if x[1] ~= bestName and x[2] >= x[3] and x[2] > secondScore then
                secondName, secondScore = x[1], x[2]
            end
        end
    end
    Rt.regimeBestName = bestName
    Rt.regimeBestScore = bestName == "NONE" and 0 or bestScore
    Rt.regimeSecondName = secondName
    Rt.regimeSecondScore = secondScore == -math.huge and 0 or secondScore
    Rt.regimeConflict = false
    Rt.regimeCompatible = false
    Rt.regimeCompatibleSide = nil
    Rt.regimeCompatibilityText = nil
    Rt.regimeCompetitorName = secondName
    Rt.regimeCompetitorScore = secondScore == -math.huge and 0 or secondScore
    Rt.regimeRawMargin = secondScore == -math.huge and bestScore or bestScore - secondScore

    -- Find same-direction trend/breakout support independently of candidate
    -- ordering. This matters when RANGE ties the breakout score and appears
    -- earlier in the table: the directional confirmation must not disappear
    -- merely because the diagnostic runner-up happens to be RANGE.
    local compatibleSide, supportName = nil, nil
    local competitorName, competitorScore = "NONE", -math.huge
    if bestName ~= "NONE" then
        for _,x in ipairs(candidates) do
            if x[1] ~= bestName and x[2] >= x[3] then
                local isCompatible, direction = compatibleTrendBreakout(bestName, x[1])
                if isCompatible then
                    compatibleSide, supportName = direction, x[1]
                elseif x[2] > competitorScore then
                    competitorName, competitorScore = x[1], x[2]
                end
            end
        end
    end
    if supportName ~= nil then
        Rt.regimeCompatible = true
        Rt.regimeCompatibleSide = compatibleSide
        Rt.regimeCompatibilityText = compatibleSide == "B"
            and ("trend+breakout bullish agreement via " .. supportName)
            or ("trend+breakout bearish agreement via " .. supportName)
    end
    Rt.regimeCompetitorName = competitorName
    Rt.regimeCompetitorScore = competitorScore == -math.huge and 0 or competitorScore
    local confidenceBonus = Rt.regimeCompatible and Cfg.TrendBreakoutConfidenceBonus or 0
    Rt.regimeEffectiveMargin = competitorScore == -math.huge
        and (bestName == "NONE" and 0 or bestScore + confidenceBonus)
        or bestScore + confidenceBonus - competitorScore

    -- Low volatility is a no-trade state unless breakout already qualified.
    if Scores.lowVol >= 7 and string.sub(bestName, 1, 8) ~= "BREAKOUT" then
        publishVolatilityOverride("LOW_VOLATILITY", Scores.lowVol, bestName, bestScore)
        return "LOW_VOLATILITY", Scores.lowVol
    end
    if Scores.highVol >= 8 and bestName == "NONE" then
        publishVolatilityOverride("HIGH_VOLATILITY", Scores.highVol, bestName, bestScore)
        return "HIGH_VOLATILITY", Scores.highVol
    end
    if bestName ~= "NONE" and competitorScore ~= -math.huge
        and Rt.regimeEffectiveMargin < Cfg.RegimeConfidenceMargin then
        Rt.regimeConflict = true
        return "NONE", 0
    end
    return bestName, bestName == "NONE" and 0 or bestScore
end

-- Live Market Pulse: adapts thresholds and risk to what the market is doing
-- on THIS closed bar (volatility, energy, session, spread, structure clarity).
-- Does not predict direction; it only raises/lowers the bar and size.
local function updateLiveMarketPulse()
    local c = Context
    local atrPct = Rt.volatilityPercentile()
    local adx = tonumber(c.adx) or 0
    local mom = abs(tonumber(c.momentumATR) or 0)
    local efficiency = tonumber(c.efficiency) or 0
    local spread = spreadPips(Rt.processingPeriod)
    local maxSpread = max(Cfg.MaxSpreadPips or 1, 0.0001)
    local spreadRatio = clamp(spread / maxSpread, 0, 3)
    local session = tostring(Rt.activeMarketSession or "OFF_HOURS")
    local st = Rt.marketStructure or {}
    local stQ = tonumber(st.quality) or 0
    local stConf = tonumber(st.confidence) or 0
    local rangePos = tonumber(c.rangePosition) or 0.5
    local midRange = abs(rangePos - 0.5) < 0.18

    -- Volatility bucket relative to recent ATR percentile
    local volState = "NORMAL"
    if atrPct <= 0.25 or (Scores.lowVol or 0) >= 6 then volState = "QUIET"
    elseif atrPct >= 0.80 or (Scores.highVol or 0) >= 7 then volState = "HOT"
    elseif atrPct >= 0.60 then volState = "ELEVATED" end

    -- Energy: how much directional movement vs noise
    local energy = clamp(0.35 * mom + 0.35 * efficiency + 0.30 * (adx / 40.0), 0, 1.5)
    local energyState = energy >= 0.85 and "STRONG" or (energy >= 0.45 and "MODERATE" or "WEAK")

    -- Session intensity (GER30: London / NY matter most)
    local sessionHeat = 0.35
    if session == "LONDON_NEW_YORK_OVERLAP" then sessionHeat = 1.0
    elseif session == "LONDON" or session == "NEW_YORK" then sessionHeat = 0.85
    elseif session == "TOKYO_LONDON_OVERLAP" then sessionHeat = 0.65
    elseif session == "TOKYO" or session == "SYDNEY_TOKYO_OVERLAP" then sessionHeat = 0.45
    elseif session == "OFF_HOURS" then sessionHeat = 0.20 end

    -- Spread stress: expensive fills → demand more edge / less size
    local spreadStress = clamp((spreadRatio - 0.5) / 1.5, 0, 1)

    -- Structure clarity
    local structureClarity = clamp((stQ / 100.0) * 0.55 + (stConf / 100.0) * 0.45, 0, 1)
    if st.choch then structureClarity = structureClarity * 0.75 end

    -- Recent outcome pressure (from Smart AI / consecutive losses)
    local outcomePressure = clamp((Rt.consecutiveLosses or 0) / max(Cfg.MaxConsecutiveLosses or 3, 1), 0, 1)
    if Rt.ML ~= nil and type(Rt.ML.calibratedWinRate) == "number" then
        if Rt.ML.calibratedWinRate < 0.35 and (Rt.ML.samples or 0) >= 15 then
            outcomePressure = max(outcomePressure, 0.55)
        end
    end

    -- Composite "trade friendliness" 0..1 (higher = conditions support trading)
    local friendliness = clamp(
        0.22 * sessionHeat
        + 0.22 * clamp(energy / 1.0, 0, 1)
        + 0.18 * structureClarity
        + 0.15 * (volState == "NORMAL" and 1.0 or (volState == "ELEVATED" and 0.7 or (volState == "HOT" and 0.45 or 0.55)))
        + 0.13 * (1.0 - spreadStress)
        + 0.10 * (1.0 - outcomePressure),
        0, 1)
    if midRange and (tostring(Rt.currentRegime or "") == "CHOPPY_RANGE"
        or tostring(Rt.smartState or "") == "RANGE") then
        friendliness = friendliness * 0.85
    end

    -- Adaptive score / edge / risk deltas derived from pulse
    local scoreAdd = 0
    local edgeAdd = 0
    local riskMult = 1.0
    local notes = {}

    if volState == "HOT" then
        scoreAdd = scoreAdd + 4
        edgeAdd = edgeAdd + 2
        notes[#notes + 1] = "hotVolScore"
    elseif volState == "QUIET" then
        scoreAdd = scoreAdd + 2
        notes[#notes + 1] = "quietVolScore"
    elseif volState == "ELEVATED" then
        scoreAdd = scoreAdd + 1
        notes[#notes + 1] = "elevVolScore"
    end

    if energyState == "WEAK" then
        scoreAdd = scoreAdd + 3
        edgeAdd = edgeAdd + 1
        riskMult = riskMult * 0.80
        notes[#notes + 1] = "weakEnergy"
    elseif energyState == "STRONG" and structureClarity >= 0.55 then
        scoreAdd = scoreAdd - 2
        riskMult = riskMult * 1.05
        notes[#notes + 1] = "strongClean"
    end

    if sessionHeat <= 0.25 then
        scoreAdd = scoreAdd + 4
        edgeAdd = edgeAdd + 2
        riskMult = riskMult * 0.65
        notes[#notes + 1] = "offHours"
    elseif sessionHeat >= 0.85 then
        scoreAdd = scoreAdd - 1
        notes[#notes + 1] = "primeSession"
    end

    if spreadStress >= 0.55 then
        scoreAdd = scoreAdd + 3
        edgeAdd = edgeAdd + 2
        riskMult = riskMult * 0.75
        notes[#notes + 1] = "wideSpread"
    end

    if structureClarity < 0.40 then
        scoreAdd = scoreAdd + 3
        edgeAdd = edgeAdd + 1
        notes[#notes + 1] = "muddyStructure"
    elseif structureClarity >= 0.75 then
        scoreAdd = scoreAdd - 1
        notes[#notes + 1] = "clearStructure"
    end

    if outcomePressure >= 0.5 then
        scoreAdd = scoreAdd + 2
        riskMult = riskMult * (1.0 - 0.25 * outcomePressure)
        notes[#notes + 1] = "outcomePressure"
    end

    riskMult = clamp(riskMult, 0.35, 1.15)
    scoreAdd = clamp(scoreAdd, -3, 10)
    edgeAdd = clamp(edgeAdd, 0, 6)

    Rt.livePulse = {
        volState = volState,
        energyState = energyState,
        energy = energy,
        sessionHeat = sessionHeat,
        spreadStress = spreadStress,
        structureClarity = structureClarity,
        outcomePressure = outcomePressure,
        friendliness = friendliness,
        scoreAdd = scoreAdd,
        edgeAdd = edgeAdd,
        riskMult = riskMult,
        note = #notes > 0 and table.concat(notes, "+") or "neutral",
        session = session,
    }
    return Rt.livePulse
end

-- Smart Market State AI: multi-factor state label + confidence + hysteresis.
-- Improves state classification accuracy; does not claim price prediction.
local function updateSmartMarketState(regime)
    if not Cfg.UseSmartMarketState then
        Rt.smartState = tostring(regime or "OFF")
        Rt.smartStateConfidence = 0
        Rt.smartStateNote = "smart state off"
        Rt.smartStateBias = "NEUTRAL"
        return
    end
    local c = Context
    local raw = tostring(regime or "NONE")
    local state = "TRANSITION"
    local bias = "NEUTRAL"
    local notes = {}

    if raw == "TRENDING_UP" or raw == "BREAKOUT_UP" then
        state = (raw == "BREAKOUT_UP") and "BULL_BREAKOUT" or "BULL_TREND"
        bias = "BULL"
    elseif raw == "TRENDING_DOWN" or raw == "BREAKOUT_DOWN" then
        state = (raw == "BREAKOUT_DOWN") and "BEAR_BREAKOUT" or "BEAR_TREND"
        bias = "BEAR"
    elseif raw == "CHOPPY_RANGE" then
        state = "RANGE"
    elseif raw == "REVERSAL_BULL" then
        state = "BULL_REVERSAL"
        bias = "BULL"
    elseif raw == "REVERSAL_BEAR" then
        state = "BEAR_REVERSAL"
        bias = "BEAR"
    elseif raw == "LOW_VOLATILITY" then
        state = "QUIET"
    elseif raw == "HIGH_VOLATILITY" then
        state = "VOLATILE"
    else
        state = "TRANSITION"
    end

    local dist = tonumber(c.vwapDistATR) or 0
    local rsi = tonumber(c.rsi) or 50
    local minStretch = Cfg.VWAPFadeMinATR or 2.0
    if Cfg.UseVWAPFade then
        if dist >= minStretch and rsi >= (Cfg.VWAPFadeRSIHigh or 70) then
            notes[#notes + 1] = "upper_VWAP_stretch"
            if state == "TRANSITION" or state == "RANGE" or state == "VOLATILE" then
                state = "FADE_SHORT_SETUP"
                bias = "BEAR"
            end
        elseif dist <= -minStretch and rsi <= (Cfg.VWAPFadeRSILow or 30) then
            notes[#notes + 1] = "lower_VWAP_stretch"
            if state == "TRANSITION" or state == "RANGE" or state == "VOLATILE" then
                state = "FADE_LONG_SETUP"
                bias = "BULL"
            end
        end
    end

    local best = tonumber(Rt.regimeBestScore) or 0
    local margin = tonumber(Rt.regimeEffectiveMargin) or 0
    local adx = tonumber(c.adx) or 0
    local plusDI = tonumber(c.plusDirection) or 0
    local minusDI = tonumber(c.minusDirection) or 0
    local conf = 32 + clamp(best * 4.5, 0, 36) + clamp(margin * 7.0, 0, 18)

    if bias == "BULL" and adx >= 22 and plusDI > minusDI then
        conf = conf + 12
        notes[#notes + 1] = "ADX+DI confirm bull"
    elseif bias == "BEAR" and adx >= 22 and minusDI > plusDI then
        conf = conf + 12
        notes[#notes + 1] = "ADX+DI confirm bear"
    elseif (state == "RANGE" or state == "QUIET") and adx < 20 then
        conf = conf + 10
        notes[#notes + 1] = "ADX confirms quiet/range"
    elseif bias ~= "NEUTRAL" and adx < 18 then
        conf = conf - 8
        notes[#notes + 1] = "weak ADX vs directional claim"
    end

    if Rt.regimeConflict then
        conf = conf - 10
        notes[#notes + 1] = "regime conflict"
    end
    if raw == "NONE" then
        conf = math.min(conf, 42)
        notes[#notes + 1] = "no dominant regime"
    end

    local st = Rt.marketStructure or {}
    if bias == "BULL" and st.bias == "BULLISH" then conf = conf + 5
    elseif bias == "BEAR" and st.bias == "BEARISH" then conf = conf + 5
    elseif bias == "BULL" and st.bias == "BEARISH" then conf = conf - 6
    elseif bias == "BEAR" and st.bias == "BULLISH" then conf = conf - 6 end

    -- Fold live pulse into confidence (hostile tape → less confident claims)
    local pulse = Rt.livePulse
    if type(pulse) == "table" then
        if pulse.volState == "HOT" then
            conf = conf - 6
            notes[#notes + 1] = "pulse_hotVol"
        elseif pulse.volState == "QUIET" and state ~= "QUIET" and state ~= "RANGE" then
            conf = conf - 4
            notes[#notes + 1] = "pulse_quiet_vs_claim"
        end
        if pulse.energyState == "WEAK" and (bias == "BULL" or bias == "BEAR") then
            conf = conf - 5
            notes[#notes + 1] = "pulse_weakEnergy"
        end
        if pulse.friendliness ~= nil and pulse.friendliness < 0.35 then
            conf = conf - 4
            notes[#notes + 1] = "pulse_hostile"
        elseif pulse.friendliness ~= nil and pulse.friendliness >= 0.70 then
            conf = conf + 3
            notes[#notes + 1] = "pulse_friendly"
        end
    end

    conf = clamp(conf, 5, 96)

    local hyst = Cfg.SmartStateHysteresis or 12
    local prev = Rt.smartState
    local prevConf = tonumber(Rt.smartStateConfidence) or 0
    if prev ~= nil and prev ~= "UNKNOWN" and prev ~= "OFF" and prev ~= state then
        if Rt.stateCandidate == state then Rt.stateCandidateBars = (Rt.stateCandidateBars or 0) + 1
        else Rt.stateCandidate, Rt.stateCandidateBars = state, 1 end
        if conf < prevConf + hyst and prevConf >= 50
            and Rt.stateCandidateBars < (Cfg.SmartStateMaxHoldBars or 3) then
            notes[#notes + 1] = "hysteresis_hold:" .. tostring(prev)
            state, bias, conf = prev, Rt.smartStateBias or "NEUTRAL", prevConf * 0.85
        else
            Rt.stateCandidate, Rt.stateCandidateBars = nil, 0
        end
    else
        Rt.stateCandidate, Rt.stateCandidateBars = nil, 0
    end

    Rt.smartState = state
    Rt.smartStateConfidence = conf
    Rt.smartStateBias = bias
    Rt.smartStateNote = (#notes > 0) and table.concat(notes, "; ") or "clean"
end

-- Re-run the identical regime selector with the unweighted directional trend
-- scores, then restore every published diagnostic field. This gives position
-- management a regime classification that cannot be changed by the optional
-- HH/HL/LH/LL entry weight while leaving the entry selector and its diagnostics
-- untouched.
local function detectBaseMarketRegime()
    local weightedTrendUp, weightedTrendDown = Scores.trendUp, Scores.trendDown
    local publishedFields = {
        "regimeBestName", "regimeBestScore", "regimeSecondName", "regimeSecondScore",
        "regimeConflict", "regimeCompatible", "regimeCompatibleSide",
        "regimeCompatibilityText", "regimeCompetitorName", "regimeCompetitorScore",
        "regimeRawMargin", "regimeEffectiveMargin"
    }
    local saved, wasNil = {}, {}
    for _,name in ipairs(publishedFields) do
        saved[name] = Rt[name]
        wasNil[name] = Rt[name] == nil
    end

    Scores.trendUp = Scores.trendUpBase or Scores.trendUp
    Scores.trendDown = Scores.trendDownBase or Scores.trendDown
    local baseRegime = detectMarketRegime()
    Scores.trendUp, Scores.trendDown = weightedTrendUp, weightedTrendDown

    for _,name in ipairs(publishedFields) do
        Rt[name] = wasNil[name] and nil or saved[name]
    end
    return baseRegime
end

-- =========================
-- Stops, targets, sizing
-- =========================
function Rt.stopATRMultiplier(regime)
    local mult = Cfg.ATRStopTrend
    if regime == "CHOPPY_RANGE" then mult = Cfg.ATRStopRange
    elseif string.sub(tostring(regime),1,8) == "BREAKOUT" then mult = Cfg.ATRStopBreakout
    elseif string.sub(tostring(regime),1,8) == "REVERSAL" then mult = Cfg.ATRStopReversal end
    return tonumber(mult) or 2.0
end

function Rt.widenedATRStop(regime)
    local atr = tonumber(Context.atr) or 0
    if atr <= 0 then atr = sourcePipSize() end
    local mult = Rt.stopATRMultiplier(regime)
    local volAdj = Rt.volatilityStopAdjustment()
    return atr * mult * volAdj, atr, mult, volAdj
end

local function calculateAdaptiveStop(regime)
    local stop, atr = Rt.widenedATRStop(regime)
    local minATR = (tonumber(Cfg.MinStopATR) or 0) * atr
    local minPips = (tonumber(Cfg.MinStopPips) or 0) * sourcePipSize()
    local spreadFloor = 0
    local spreadMult = tonumber(Cfg.StopSpreadMultiple) or 0
    if spreadMult > 0 then
        local sp = spreadPips(Context.p or Rt.processingPeriod)
        if validNumber(sp) and sp > 0 then
            spreadFloor = sp * spreadMult * sourcePipSize()
        end
    end
    return max(max(stop, minATR), max(minPips, spreadFloor))
end

local function calculateAdaptiveTarget(regime, stopDistance)
    local rr = Cfg.RRTrend
    if regime == "CHOPPY_RANGE" then rr = Cfg.RRRange
    elseif string.sub(regime,1,8) == "BREAKOUT" then rr = Cfg.RRBreakout
    elseif string.sub(regime,1,8) == "REVERSAL" then rr = Cfg.RRReversal end
    return stopDistance * rr
end

local function currentStrategyUnits()
    if not Cfg.AllowTrade or not checkReady("trades") then return 0 end
    local trades = core.host:findTable("trades")
    if trades == nil then return 0 end
    local total = 0
    local enum = trades:enumerator()
    local row = enum:next()
    while row ~= nil do
        local lot = tonumber(row.Lot)
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer and row.QTXT == Cfg.CustomID
            and validNumber(lot) then
            total = total + lot
        end
        row = enum:next()
    end
    return total
end

local function capUnitsToExposure(units)
    if units <= 0 then return 0 end
    units = math.min(units, Cfg.MaxUnits)
    local remaining = Cfg.MaxTotalUnits - currentStrategyUnits()
    if remaining < Rt.BaseSize then return 0 end
    return roundDownToBase(math.min(units, remaining))
end

function Rt.moneyGuardEnabled()
    return Cfg.SizingMode == "AdaptiveRisk" or Cfg.FixedLotRiskGuard == true
end

-- FXCM/ForexConnect exposes Offers.PipCost as the account-currency cost of one
-- broker pip for one lot, where one lot is the account/instrument baseUnitSize.
-- AUTO_BROKER is deliberately fail-closed: a stale/manual fallback must never
-- silently change the monetary risk model. MANUAL remains an explicit override.
function Rt.resolvePipValue()
    local mode = tostring(Cfg.PipValueMode or "AUTO_BROKER")
    if mode == "MANUAL" then
        local manual = tonumber(Cfg.PipValuePerBaseUnit)
        if validNumber(manual) and manual > 0 then
            Rt.EffectivePipValuePerBaseUnit = manual
            Rt.PipValueSource = "MANUAL_OVERRIDE"
            Rt.PipValueError = nil
            Rt.BrokerPipCost = nil
            Rt.BrokerPointSize = nil
            return manual, Rt.PipValueSource
        end
        Rt.EffectivePipValuePerBaseUnit = nil
        Rt.PipValueSource = "MANUAL_INVALID"
        Rt.PipValueError = "manual pip value must be > 0"
        return nil, Rt.PipValueError
    end

    local offers = core.host:findTable("offers")
    if offers == nil then
        Rt.EffectivePipValuePerBaseUnit = nil
        Rt.PipValueSource = "BROKER_UNAVAILABLE"
        Rt.PipValueError = "offers table unavailable"
        return nil, Rt.PipValueError
    end
    local row = nil
    if Rt.Offer ~= nil then
        local ok, found = pcall(function() return offers:find("OfferID", Rt.Offer) end)
        if ok then row = found end
    end
    if row == nil then
        local ok, found = pcall(function() return offers:find("Instrument", instance.bid:instrument()) end)
        if ok then row = found end
    end
    if row == nil then
        Rt.EffectivePipValuePerBaseUnit = nil
        Rt.PipValueSource = "BROKER_UNAVAILABLE"
        Rt.PipValueError = "offer row unavailable"
        return nil, Rt.PipValueError
    end

    local okCost, brokerCost = pcall(function() return tonumber(row.PipCost) end)
    if not okCost or not validNumber(brokerCost) or brokerCost <= 0 then
        Rt.EffectivePipValuePerBaseUnit = nil
        Rt.PipValueSource = "BROKER_INVALID"
        Rt.PipValueError = "Offers.PipCost unavailable or invalid"
        return nil, Rt.PipValueError
    end

    local brokerPoint = nil
    local okPoint, point = pcall(function() return tonumber(row.PointSize) end)
    if okPoint and validNumber(point) and point > 0 then brokerPoint = point end
    local sourcePip = sourcePipSize()
    if brokerPoint ~= nil and validNumber(sourcePip) and sourcePip > 0 then
        local scale = math.max(math.abs(brokerPoint), math.abs(sourcePip), 1e-12)
        if math.abs(brokerPoint - sourcePip) > scale * 1e-6 then
            Rt.EffectivePipValuePerBaseUnit = nil
            Rt.PipValueSource = "BROKER_PIPSIZE_MISMATCH"
            Rt.PipValueError = string.format("broker PointSize %.10f differs from source pip %.10f", brokerPoint, sourcePip)
            return nil, Rt.PipValueError
        end
    end

    Rt.EffectivePipValuePerBaseUnit = brokerCost
    Rt.PipValueSource = "BROKER_OFFERS.PipCost"
    Rt.PipValueError = nil
    Rt.BrokerPipCost = brokerCost
    Rt.BrokerPointSize = brokerPoint
    return brokerCost, Rt.PipValueSource
end

function Rt.pipValueDiagnostic()
    local value = tonumber(Rt.EffectivePipValuePerBaseUnit)
    return string.format("PIP_VALUE | mode=%s effective=%s source=%s brokerPipCost=%s manual=%s baseSize=%s sourcePip=%s brokerPoint=%s status=%s",
        tostring(Cfg.PipValueMode or "AUTO_BROKER"),
        validNumber(value) and string.format("%.8f", value) or "NA",
        tostring(Rt.PipValueSource or "UNRESOLVED"),
        validNumber(Rt.BrokerPipCost) and string.format("%.8f", Rt.BrokerPipCost) or "NA",
        validNumber(Cfg.PipValuePerBaseUnit) and string.format("%.8f", Cfg.PipValuePerBaseUnit) or "NA",
        tostring(Rt.BaseSize or "NA"),
        validNumber(sourcePipSize()) and string.format("%.10f", sourcePipSize()) or "NA",
        validNumber(Rt.BrokerPointSize) and string.format("%.10f", Rt.BrokerPointSize) or "NA",
        tostring(Rt.PipValueError or "OK"))
end

function Rt.riskCashPerLot(stopDistance)
    local pip, value = sourcePipSize(), Rt.EffectivePipValuePerBaseUnit
    if not validNumber(pip) or pip <= 0 or not validNumber(value) or value <= 0
        or not validNumber(stopDistance) or stopDistance < 0 then return nil end
    return (stopDistance / pip + (Cfg.RiskSlippagePips or 0)) * value
        + (Cfg.RoundTripCommissionPerLot or 0)
end

function Rt.breakEvenCostOffset()
    local costs = Rt.riskCashPerLot(0)
    local value = Rt.EffectivePipValuePerBaseUnit
    if not validNumber(costs) or not validNumber(value) or value <= 0 then return 0 end
    return costs / value * sourcePipSize()
end

function Rt.availableRiskBudget(scale)
    -- A failed refresh must not leave a previous successful budget usable.
    Rt.moneyBudget = nil
    local equity = getAccountEquity()
    if not validNumber(equity) or equity <= 0 then return nil, "account equity unavailable" end
    if not validNumber(Rt.sessionStartEquity) or Rt.sessionStartEquity <= 0
        or not Rt.sessionRiskReady then return nil, "daily risk baseline unavailable" end
    if not checkReady("trades") then return nil, "trades table not ready" end
    local trades = core.host:findTable("trades")
    if trades == nil then return nil, "trades table unavailable" end
    if not validNumber(Rt.BaseSize) or Rt.BaseSize <= 0 then return nil, "base size unavailable" end
    local entryRisk, futureRisk = 0, 0
    local enum = trades:enumerator()
    local row = enum:next()
    while row ~= nil do
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer and row.QTXT == Cfg.CustomID then
            local open, qty = tonumber(row.Open), tonumber(row.Lot)
            local stop = tonumber(row.Stop)
            if (not validNumber(stop) or stop <= 0) and Rt.liveStopRate ~= nil then
                stop = Rt.liveStopRate(row)
            end
            local price = tonumber(row.BS == "B" and instance.bid[NOW] or instance.ask[NOW])
            if (row.BS ~= "B" and row.BS ~= "S") or not validNumber(open)
                or not validNumber(qty) or qty <= 0 or not validNumber(stop) or stop <= 0
                or not validNumber(price) then return nil, "open trade risk unavailable: " .. tostring(row.TradeID) end
            local sign = row.BS == "B" and 1 or -1
            local loss = Rt.riskCashPerLot(max(0, sign * (open - stop)))
            local downside = Rt.riskCashPerLot(max(0, sign * (price - stop)))
            if loss == nil or downside == nil then return nil, "verified pip value required" end
            entryRisk = entryRisk + loss * qty / Rt.BaseSize
            futureRisk = futureRisk + downside * qty / Rt.BaseSize
        end
        row = enum:next()
    end

    -- v9.2.15: keep the operator's HARD per-trade risk ceiling separate from
    -- Smart Money's SOFT scaling. FixedLots is checked against hardAllowed;
    -- AdaptiveRisk is sized from softAllowed. Open-risk and daily-room rails
    -- remain hard constraints for BOTH modes.
    local hardPerTrade = equity * Cfg.RiskPct / 100
    local smartScale = clamp(scale or 1, 0, 1)
    local softPerTrade = hardPerTrade * smartScale
    local openRoom = equity * Cfg.MaxOpenRiskPct / 100 - entryRisk
    -- Equity already includes floating P/L. Reserve the possible giveback from
    -- CURRENT executable prices to stops, not only original entry-side loss.
    local dailyRoom = equity - Rt.sessionStartEquity * (1 - Cfg.MaxDailyLossPct / 100) - futureRisk
    local hardBudget = max(0, min(hardPerTrade, min(openRoom, dailyRoom)))
    local softBudget = max(0, min(softPerTrade, min(openRoom, dailyRoom)))
    Rt.moneyBudget = {
        perTrade=softPerTrade, hardPerTrade=hardPerTrade, softPerTrade=softPerTrade,
        smartScale=smartScale, openRisk=entryRisk, futureRisk=futureRisk,
        openRoom=openRoom, dailyRoom=dailyRoom,
        hardAllowed=hardBudget, softAllowed=softBudget, allowed=softBudget
    }
    return softBudget, string.format(
        "soft=%.2f hard=%.2f smartScale=%.2f hardPerTrade=%.2f softPerTrade=%.2f openRoom=%.2f dailyRoom=%.2f",
        softBudget, hardBudget, smartScale, hardPerTrade, softPerTrade, openRoom, dailyRoom)
end

function Rt.selectedRiskBudget()
    local b = Rt.moneyBudget or {}
    if Cfg.SizingMode == "FixedLots" then
        return tonumber(b.hardAllowed) or tonumber(b.allowed) or 0, "HARD"
    end
    return tonumber(b.softAllowed) or tonumber(b.allowed) or 0, "SMART"
end

function Rt.orderDistances(regime, stopDistance, targetDistance, spread)
    local pip = sourcePipSize()
    if not validNumber(pip) or pip <= 0 or not validNumber(Context.atr) or Context.atr <= 0
        or not validNumber(spread) or spread < 0 or spread >= 999999 then return nil, nil end

    local widenedATR = Rt.widenedATRStop(regime)
    local stop = stopDistance
    if Cfg.SetStop then
        local fixedStop = (tonumber(Cfg.Stop) or 0) * pip
        local policy = tostring(Cfg.FixedStopVolatilityPolicy or "FIXED_WITH_FLOORS")
        if policy == "ADAPTIVE" then
            stop = widenedATR
        elseif policy == "FIXED_WITH_VOLATILITY" then
            stop = max(fixedStop, widenedATR)
        else
            stop = fixedStop
        end
    end
    if not validNumber(stop) or stop <= 0 then return nil, nil end

    -- Safety floors are always mandatory and are re-evaluated with the live
    -- spread in marketOrder() immediately before submission.
    stop = max(stop, max(Cfg.MinStopATR * Context.atr,
        max(Cfg.MinStopPips * pip, Cfg.StopSpreadMultiple * spread * pip)))
    local target = Cfg.SetLimit and Cfg.Limit * pip or calculateAdaptiveTarget(regime, stop)
    if not validNumber(target) or target <= 0 then return nil, nil end
    return stop, target
end

local function smartRiskScale(entryScore, entryRequired, tradeRegime)
    -- Returns a multiplier applied to RiskPct. Default 1.0 preserves legacy sizing.
    local scale = 1.0
    local notes = {}
    if not Cfg.UseSmartMoneyManagement then return scale, "off" end

    if Cfg.ScaleRiskByQuality then
        local required = tonumber(entryRequired) or Cfg.ProbabilityScoreMin or 65
        local score = tonumber(entryScore) or required
        local span = 25.0
        local t = clamp((score - required) / span, -1.0, 1.0)
        local lo = Cfg.RiskScaleMin or 0.5
        local hi = Cfg.RiskScaleMax or 1.0
        local qualityScale = lo + (hi - lo) * ((t + 1.0) * 0.5)
        scale = scale * qualityScale
        notes[#notes + 1] = string.format("quality=%.2f", qualityScale)
    end

    if Cfg.ScaleRiskByLossStreak and (Rt.consecutiveLosses or 0) > 0 then
        local factor = Cfg.LossStreakFactor or 0.7
        local streakScale = factor ^ Rt.consecutiveLosses
        scale = scale * streakScale
        notes[#notes + 1] = string.format("streakx%d=%.2f", Rt.consecutiveLosses, streakScale)
    end

    if Cfg.ScaleRiskByDrawdown and Rt.sessionStartEquity ~= nil and Rt.sessionStartEquity > 0 then
        local eq = getAccountEquity()
        if validNumber(eq) then
            local ddPct = max(0, (Rt.sessionStartEquity - eq) / Rt.sessionStartEquity * 100.0)
            local cap = max(Cfg.MaxDailyLossPct or 2.0, 0.01)
            local startFrac = clamp(Cfg.DrawdownScaleStartPct or 0.5, 0.05, 1.0)
            local startPct = cap * startFrac
            if ddPct >= startPct then
                local room = cap - startPct
                local ddScale = room <= 0 and 0.25
                    or clamp(1.0 - (ddPct - startPct) / room, 0.25, 1.0)
                scale = scale * ddScale
                notes[#notes + 1] = string.format("dd=%.2f", ddScale)
            end
        end
    end

    -- Apply volatility exactly once through the dedicated smooth lookup curve.
    -- This replaces the old stacked highVol x pulse-volatility cuts.
    local volPct = Rt.volatilityPercentile()
    local volRisk = Rt.volatilityRiskMultiplier(volPct)
    scale = scale * volRisk
    notes[#notes + 1] = string.format("volx=%.2f@%.2f", volRisk, volPct)

    if string.sub(tostring(tradeRegime or ""), 1, 8) == "REVERSAL" then
        scale = scale * 0.75
        notes[#notes + 1] = "reversal=0.75"
    end

    -- Live pulse multiplier now covers non-volatility context only
    -- (session/spread/energy/structure/outcome). Volatility is applied above once.
    local pulse = Rt.livePulse
    if type(pulse) == "table" and validNumber(pulse.riskMult) then
        scale = scale * pulse.riskMult
        notes[#notes + 1] = string.format("pulse=%.2f[%s]", pulse.riskMult, tostring(pulse.note or "n"))
    end

    scale = clamp(scale, 0, min(Cfg.RiskScaleMax or 1.0, 1.0))
    return scale, #notes > 0 and table.concat(notes, ",") or "1.0"
end

local function calculatePositionSize(stopDistance, tradeRegime, entryScore, entryRequired)
    -- Includes failures before availableRiskBudget(), such as missing pip cost.
    Rt.moneyBudget = nil
    if not Cfg.AllowTrade then return 1 end
    Rt.lastSizingReason = nil
    if not validNumber(stopDistance) or stopDistance <= 0 then
        Rt.lastSizingReason = "invalid stop distance"; return 0
    end
    if not Rt.moneyGuardEnabled() then
        Rt.lastRiskScale, Rt.lastRiskScaleNote = nil, "manual fixed lots; monetary sizing guard OFF"
        if not validNumber(Rt.BaseSize) or Rt.BaseSize <= 0 or not validNumber(Cfg.Amount)
            or Cfg.Amount <= 0 then return 0 end
        return capUnitsToExposure(roundDownToBase(Cfg.Amount * Rt.BaseSize))
    end
    local pipValue, pipReason = Rt.resolvePipValue()
    if not validNumber(pipValue) or pipValue <= 0 then
        Rt.lastSizingReason = "pip value unavailable: " .. tostring(pipReason); return 0
    end
    local perLot = Rt.riskCashPerLot(stopDistance)
    if not validNumber(perLot) or perLot <= 0 then
        Rt.lastSizingReason = "broker/manual pip value could not price risk"; return 0
    end
    local scale, note = smartRiskScale(entryScore, entryRequired, tradeRegime)
    local softBudget, reason = Rt.availableRiskBudget(scale)
    Rt.lastRiskScale, Rt.lastRiskScaleNote = scale, note
    Rt.lastSizingReason = reason
    if not validNumber(softBudget) or Rt.moneyBudget == nil then
        Rt.lastSizingReason = "risk budget refresh failed: " .. tostring(reason or "unavailable")
        return 0
    end
    if Cfg.SizingMode == "FixedLots" then
        -- v9.2.15: FixedLots remains a PASS/FAIL operator-requested size, but
        -- it is tested against the HARD RiskPct/open-risk/daily-room budget.
        -- Smart Money scaling is still calculated and logged, but it cannot
        -- shrink an otherwise hard-affordable minimum fixed lot to zero.
        local hardBudget = Rt.moneyBudget ~= nil and tonumber(Rt.moneyBudget.hardAllowed) or nil
        if not validNumber(hardBudget) or hardBudget <= 0 then
            Rt.lastSizingReason = "hard guarded risk budget unavailable or exhausted"
            return 0
        end
        local requestedLots = min(Cfg.Amount, Cfg.MaxLots)
        if requestedLots < Cfg.MinLots then
            Rt.lastSizingReason = "fixed requested lots below configured minimum"
            return 0
        end
        local requestedRisk = perLot * requestedLots
        if requestedRisk > hardBudget + 1e-9 then
            local equity = getAccountEquity()
            local requiredPct = validNumber(equity) and equity > 0 and (requestedRisk / equity * 100) or nil
            Rt.lastSizingReason = requiredPct ~= nil
                and string.format("fixed %.2f lot risk %.2f exceeds HARD budget %.2f; requires at least %.2f%% equity before other hard rails", requestedLots, requestedRisk, hardBudget, requiredPct)
                or string.format("fixed %.2f lot risk %.2f exceeds HARD budget %.2f", requestedLots, requestedRisk, hardBudget)
            return 0
        end
        Rt.lastSizingReason = string.format(
            "fixed %.2f lot accepted: risk %.2f <= HARD budget %.2f; smart soft budget %.2f is diagnostic-only",
            requestedLots, requestedRisk, hardBudget, tonumber(softBudget) or 0)
        return capUnitsToExposure(roundDownToBase(requestedLots * Rt.BaseSize))
    end
    if not validNumber(softBudget) or softBudget <= 0 then return 0 end
    local lots = min(softBudget / perLot, Cfg.MaxLots)
    -- Adaptive sizing rounds only downward.
    if lots < Cfg.MinLots then return 0 end
    return capUnitsToExposure(roundDownToBase(lots * Rt.BaseSize))
end

-- =========================
-- Risk / table state
-- =========================
local function ownTradesSnapshot()
    if not Cfg.AllowTrade then return 0, 0, 0 end
    if not checkReady("trades") then return 0, 0, 0 end
    local trades = core.host:findTable("trades")
    if trades == nil then return 0, 0, 0 end
    local enum = trades:enumerator()
    local row = enum:next()
    local total, buys, sells = 0, 0, 0
    while row ~= nil do
        local qty = tonumber(row.Lot) or 0
        local tradeId = row.TradeID ~= nil and tostring(row.TradeID) or ""
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer and row.QTXT == Cfg.CustomID
            and qty > 0 and tradeId ~= "" and (row.BS == "B" or row.BS == "S") then
            total = total + 1
            if row.BS == "B" then buys = buys + 1
            elseif row.BS == "S" then sells = sells + 1 end
        end
        row = enum:next()
    end
    return total, buys, sells
end

local function ownTradesCount(side)
    local total, buys, sells = ownTradesSnapshot()
    if side == "B" then return buys or 0 end
    if side == "S" then return sells or 0 end
    return total or 0
end

local function entryPositionConflict(side)
    if not Cfg.AllowTrade then return false, nil end
    if not checkReady("trades") then return true, "trades table not ready" end
    local trades = core.host:findTable("trades")
    if trades == nil then return true, "trades table unavailable" end
    local opposite = side == "B" and "S" or "B"
    local enum = trades:enumerator()
    local row = enum:next()
    while row ~= nil do
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer then
            if not Rt.HedgingEnabled and row.BS == opposite then
                local owner = row.QTXT == Cfg.CustomID and "this strategy" or "unrelated/manual"
                return true, owner .. " opposite TradeID=" .. tostring(row.TradeID)
            end
            -- FIFO/ELS protection and net closes are account/instrument-side
            -- scoped. Do not open beside a same-side position we do not own.
            if not Rt.CanClose and row.BS == side and row.QTXT ~= Cfg.CustomID then
                return true, "unrelated/manual same-side FIFO TradeID=" .. tostring(row.TradeID)
            end
        end
        row = enum:next()
    end
    return false, nil
end

local function hasPendingOpenRequest()
    return Rt.pendingUnknownOpen ~= nil or next(Rt.pendingOpenRequests) ~= nil
end

local function hasPendingCloseRequest()
    return next(Rt.closePendingTradeIds) ~= nil or next(Rt.fifoClosePending) ~= nil
        or next(Rt.awaitingCloseReconciliation) ~= nil
end

local function clearReconciledCloseState(tradeId, side)
    if tradeId ~= nil then
        local key = tostring(tradeId)
        Rt.awaitingCloseReconciliation[key] = nil
        Rt.closePendingTradeIds[tradeId] = nil
        Rt.closePendingTradeIds[key] = nil
        local numericId = tonumber(tradeId)
        if numericId ~= nil then Rt.closePendingTradeIds[numericId] = nil end
        for cookie, tracked in pairs(Rt.pendingCloseCookies) do
            if tracked.tradeId ~= nil and tostring(tracked.tradeId) == key then
                Rt.pendingCloseCookies[cookie] = nil
            end
        end
    end
    if side ~= nil then
        local pending = Rt.fifoClosePending[side]
        if type(pending) == "table" and pending.cookie ~= nil then
            Rt.pendingCloseCookies[pending.cookie] = nil
        end
        Rt.fifoClosePending[side] = nil
    end
end

local function forgetOpenCookiesForPending(target)
    for cookie, tracked in pairs(Rt.pendingOpenCookies) do
        if tracked.pending == target then Rt.pendingOpenCookies[cookie] = nil end
    end
end

local function releaseUnfilledOpenState(pending)
    if pending == nil then return end
    if pending.setupKey ~= nil and Rt.usedSetupKeys[pending.setupKey] == pending.period then
        Rt.usedSetupKeys[pending.setupKey] = nil
    end
    if pending.globalSetupKey ~= nil and Rt.usedSetupKeys[pending.globalSetupKey] == pending.period then
        Rt.usedSetupKeys[pending.globalSetupKey] = nil
    end
    if Rt.lastEntryPeriod == pending.period then
        Rt.lastEntryPeriod = nil
    end
    persistEntryRuntimeState()
end

local function pruneStalePendingOpens(p)
    -- A pending open should always be resolved within a few bars by
    -- ExtAsyncOperationFinished (confirm) or by the trade appearing in the
    -- trades table (bindTradeInitialRisk clears it). If a callback is ever
    -- dropped, or a request ID can't be matched to the trade that eventually
    -- appears, a pending entry could otherwise sit forever and
    -- hasPendingOpenRequest() would block all future entries permanently.
    -- An unresolved accepted request is not proof of rejection. Releasing its
    -- setup/cooldown lock could permit a second entry immediately before a late
    -- fill appears. Keep the request quarantined and fail closed until the trade
    -- table binds it, an explicit rejection arrives, or the operator verifies
    -- broker state and restarts the instance.
    for id, pending in pairs(Rt.pendingOpenRequests) do
        if pending.period ~= nil and p - pending.period >= Cfg.PendingOpenTimeoutBars then
            if not pending.timeoutAlerted then
                pending.timeoutAlerted = true
                alert(string.format("PENDING OPEN SAFETY LOCK: reqID=%s side=%s unresolved after %d bars; entry remains blocked until broker state resolves", tostring(id), tostring(pending.side), p - pending.period))
            end
        end
    end
    if Rt.pendingUnknownOpen ~= nil and Rt.pendingUnknownOpen.period ~= nil
        and p - Rt.pendingUnknownOpen.period >= Cfg.PendingOpenTimeoutBars then
        if not Rt.pendingUnknownOpen.timeoutAlerted then
            Rt.pendingUnknownOpen.timeoutAlerted = true
            alert(string.format("PENDING OPEN SAFETY LOCK: unknown-ID open side=%s unresolved after %d bars; entry remains blocked until broker state resolves", tostring(Rt.pendingUnknownOpen.side), p - Rt.pendingUnknownOpen.period))
        end
    end
end

local function pruneStalePendingCloses(p)
    for tradeId, pending in pairs(Rt.awaitingCloseReconciliation) do
        local period = type(pending) == "table" and pending.period or nil
        if period ~= nil and p - period >= Cfg.PendingCloseTimeoutBars
            and not pending.timeoutAlerted then
            pending.timeoutAlerted = true
            alert(string.format("CLOSE RECONCILIATION SAFETY LOCK: TradeID=%s absent from open trades but no final closed row after %d bars; new entries remain blocked",
                tostring(tradeId), p - period))
        end
    end
    for tradeId, pending in pairs(Rt.closePendingTradeIds) do
        local period = type(pending) == "table" and pending.period or nil
        if period ~= nil and p - period >= Cfg.PendingCloseTimeoutBars then
            if pending.accepted then
                if not pending.timeoutAlerted then
                    pending.timeoutAlerted = true
                    alert(string.format("PENDING CLOSE SAFETY LOCK: TradeID=%s accepted but still visible after %d bars; duplicate close suppressed",
                        tostring(tradeId), p - period))
                end
            else
                if pending.cookie ~= nil then Rt.pendingCloseCookies[pending.cookie] = nil end
                Rt.closePendingTradeIds[tradeId] = nil
                alert(string.format("PENDING CLOSE TIMEOUT: TradeID=%s unconfirmed after %d bars; exit may be retried",
                    tostring(tradeId), p - period))
            end
        end
    end
    for side, pending in pairs(Rt.fifoClosePending) do
        local period = type(pending) == "table" and pending.period or nil
        if period ~= nil and p - period >= Cfg.PendingCloseTimeoutBars then
            if pending.accepted then
                if not pending.timeoutAlerted then
                    pending.timeoutAlerted = true
                    alert(string.format("PENDING FIFO CLOSE SAFETY LOCK: side=%s accepted but still visible after %d bars; duplicate close suppressed",
                        tostring(side), p - period))
                end
            else
                if pending.cookie ~= nil then Rt.pendingCloseCookies[pending.cookie] = nil end
                Rt.fifoClosePending[side] = nil
                alert(string.format("PENDING FIFO CLOSE TIMEOUT: side=%s unconfirmed after %d bars; exit may be retried",
                    tostring(side), p - period))
            end
        end
    end
    for tradeId, pending in pairs(Rt.pendingStopEdits) do
        local period = type(pending) == "table" and pending.period or nil
        local confirmed = false
        if pending.orderId ~= nil and checkReady("orders") then
            local orders = core.host:findTable("orders")
            local orderRow = orders ~= nil and orders:find("OrderID", pending.orderId) or nil
            local liveRate = orderRow ~= nil and tonumber(orderRow.Rate) or nil
            local point = Rt.Source ~= nil and (10 ^ (-Rt.Source:getPrecision())) or 0
            if orderRow ~= nil and tostring(orderRow.Type or "") == "S"
                and orderRow.AccountID == Rt.Account and orderRow.OfferID == Rt.Offer
                and validNumber(liveRate) and abs(liveRate - pending.requestedRate) <= point * 0.5 then
                confirmed = true
                Rt.brokerStopRates[tradeId] = pending.requestedRate
                if pending.cookie ~= nil then Rt.pendingStopEditCookies[pending.cookie] = nil end
                Rt.pendingStopEdits[tradeId] = nil
                debug(string.format("BROKER STOP TABLE CONFIRMED | TradeID=%s OrderID=%s stop=%.5f",
                    tostring(tradeId), tostring(pending.orderId), pending.requestedRate))
            end
        end
        if not confirmed and period ~= nil and p - period >= Cfg.PendingCloseTimeoutBars
            and not pending.timeoutAlerted then
            pending.timeoutAlerted = true
            alert(string.format("PENDING STOP EDIT SAFETY LOCK: TradeID=%s OrderID=%s unresolved after %d bars; duplicate edits suppressed, synthetic exit retained",
                tostring(tradeId), tostring(pending.orderId), p - period))
        end
    end
end

local function parseOrderRequestId(message)
    if message == nil then return nil end
    local ok, fields = pcall(function() return core.parseCsv(tostring(message), ",") end)
    if not ok or fields == nil then return nil end
    local requestId = fields[0] or fields[1]
    if requestId == nil or tostring(requestId) == "" then return nil end
    return tostring(requestId)
end

local function resetSessionStatistics(dateValue)
    local utcKey = getUTCDayKey(dateValue)
    if Rt.lossStreakUTCKey ~= utcKey then
        Rt.lossStreakUTCKey = utcKey
        Rt.consecutiveLosses = 0
        -- Loss-result deduplication follows the same UTC boundary as the
        -- streak. Clearing this at session midnight can recount the same
        -- UTC trades when Session Time Zone is not UTC.
        Rt.knownClosedTrades = {}
        debug("Consecutive-loss streak reset at UTC day boundary: " .. utcKey)
    end

    local key = getDayKey(dateValue)
    if Rt.sessionKey ~= key then
        Rt.sessionKey = key
        Rt.dailyLossLocked = tostring(runtimeGet("dailyLossLockSession", "")) == key
        local storedKey = tostring(runtimeGet("riskSessionKey", "") or "")
        local storedBaseline = tonumber(runtimeGet("riskSessionStartEquity", ""))
        if Cfg.AllowTrade and storedKey == key and validNumber(storedBaseline) and storedBaseline > 0 then
            Rt.sessionStartEquity = storedBaseline
            Rt.sessionRiskReady = true
        else
            Rt.sessionStartEquity = nil
            Rt.sessionRiskReady = not Cfg.AllowTrade
        end
        -- This state follows the selected daily-equity timezone. The loss
        -- streak has its own independent 00:00 UTC boundary above.
        debug("Session reset: " .. key .. "; rebuilding equity/loss state")
    end
end

local function closedTradeNetPL(row)
    local gross = tonumber(row.GrossPL)
    if not validNumber(gross) then return nil end
    local commission = tonumber(row.Com) or 0
    local interest = tonumber(row.Int) or 0
    return gross + commission + interest
end

local function closedTradeCustomID(row)
    return row.OQTXT
end

local function closedTradeEventID(row)
    -- Fallback identity for hosts/rows that do not expose TradeID.
    return table.concat({
        "CT", tostring(row.CloseOrderID or ""), tostring(row.TradeID or ""),
        tostring(row.CloseOrderReqID or ""), tostring(row.CloseTime or ""),
        tostring(row.Lot or ""), tostring(row.Close or "")
    }, ":")
end

local function nonEmptyString(value)
    if value == nil then return nil end
    local text = tostring(value)
    if text == "" then return nil end
    return text
end

local function analyticsValue(value, decimals)
    if value == nil then return "NA" end
    if type(value) == "number" then
        if not validNumber(value) then return "NA" end
        return string.format("%." .. tostring(decimals or 5) .. "f", value)
    end
    local text = tostring(value)
    text = string.gsub(text, "[\r\n|]", " ")
    text = string.gsub(text, "%s+", " ")
    return text ~= "" and text or "NA"
end

local function analyticsMessage(fields)
    local parts = {"schema=ARS_TRADE_V3", "strategy_version=" .. STRATEGY_VERSION}
    for i = 1, #fields do
        parts[#parts + 1] = tostring(fields[i][1]) .. "="
            .. analyticsValue(fields[i][2], fields[i][3])
    end
    return table.concat(parts, "|")
end

function Rt.emitOpenConfirmed(tradeRow, pending, risk, initialStop, initialTarget, quantity, openRate)
    if tradeRow == nil or pending == nil then return end
    local tradeId = tradeRow.TradeID
    if tradeId == nil then return end
    local pip = sourcePipSize()
    local stopPips = validNumber(openRate) and validNumber(initialStop)
        and abs(openRate - initialStop) / pip or nil
    local targetPips = validNumber(openRate) and validNumber(initialTarget)
        and abs(initialTarget - openRate) / pip or nil
    local text = string.format(
        "%s | OPEN_CONFIRMED TradeID=%s engine=%s side=%s regime=%s entryType=%s units=%s fill=%s SL=%s TP=%s score=%s/%s setup=%s sameBar=%s mlSnapshot=%s",
        STRATEGY_NAME, tostring(tradeId), tostring(pending.entryEngine or "UNKNOWN"), tradeRow.BS == "B" and "BUY" or "SELL",
        tostring(pending.regime or "NA"), tostring(pending.entryType or "NA"),
        quantity ~= nil and tostring(quantity) or "NA",
        validNumber(openRate) and string.format("%.5f", openRate) or "NA",
        validNumber(stopPips) and string.format("%.1fp", stopPips) or "NA",
        validNumber(targetPips) and string.format("%.1fp", targetPips) or "NA",
        validNumber(pending.score) and string.format("%.1f", pending.score) or "NA",
        validNumber(pending.required) and string.format("%.1f", pending.required) or "NA",
        tostring(pending.setupKey or "NA"), pending.reconciledSameBar and "Y" or "N",
        pending.mlFeatures ~= nil and "Y" or "N")
    writeCSVLog("OPEN_CONFIRMED", text, tradeRow.Time or tradeRow.OpenTime or pending.submittedAt)
    if Cfg.ShowCleanDiagnostics or Cfg.ShowDebug then
        emitTerminalDiagnostic(text)
    elseif Cfg.ShowAlerts then
        alert(text)
    end
end

local function tradeAnalyticsSnapshot(tradeRow, pending, risk)
    local tradeId = tradeRow.TradeID
    local existing = Rt.tradeAnalytics[tradeId] or Rt.tradeAnalytics[tostring(tradeId)]
    if existing ~= nil then return existing end

    local openRate = tonumber(tradeRow.Open)
    local quantity = tonumber(tradeRow.Lot)
    local initialStop = tonumber(tradeRow.Stop)
    if (not validNumber(initialStop) or initialStop <= 0) and validNumber(openRate)
        and validNumber(risk) and risk > 0 then
        initialStop = tradeRow.BS == "B" and (openRate - risk) or (openRate + risk)
    end
    local targetDistance = pending ~= nil and tonumber(pending.target) or nil
    local initialTarget = tonumber(tradeRow.Limit)
    if (not validNumber(initialTarget) or initialTarget <= 0) and validNumber(openRate)
        and validNumber(targetDistance) and targetDistance > 0 then
        initialTarget = tradeRow.BS == "B" and (openRate + targetDistance) or (openRate - targetDistance)
    end

    local snapshot = {
        tradeId=tradeId, side=tradeRow.BS, quantity=quantity,
        entryPrice=openRate, entryTime=tradeRow.Time or tradeRow.OpenTime,
        entryPeriod=pending ~= nil and pending.period or nil,
        initialRisk=risk, initialStop=initialStop, initialTarget=initialTarget,
        entryRegime=pending ~= nil and pending.regime or Rt.tradeEntryRegime[tradeId],
        entryEngine=pending ~= nil and pending.entryEngine or Rt.tradeEntryEngine[tradeId],
        entryBaseRegime=pending ~= nil and pending.baseRegime or nil,
        setupKey=pending ~= nil and pending.setupKey or nil,
        setupAnchor=pending ~= nil and pending.setupAnchor or Rt.tradeSetupAnchor[tradeId],
        score=pending ~= nil and pending.score or nil,
        required=pending ~= nil and pending.required or nil,
        signalPrice=pending ~= nil and pending.signalPrice or nil,
        signalATR=pending ~= nil and pending.signalATR or nil,
        signalEMAfast=pending ~= nil and pending.signalEMAfast or nil,
        signalEMAmed=pending ~= nil and pending.signalEMAmed or nil,
        signalEMAslow=pending ~= nil and pending.signalEMAslow or nil,
        signalPriceToFastEMAATR=pending ~= nil and pending.signalPriceToFastEMAATR or nil,
        signalPriceToMedEMAATR=pending ~= nil and pending.signalPriceToMedEMAATR or nil,
        signalPriceToSlowEMAATR=pending ~= nil and pending.signalPriceToSlowEMAATR or nil,
        signalFastMedGapATR=pending ~= nil and pending.signalFastMedGapATR or nil,
        signalMedSlowGapATR=pending ~= nil and pending.signalMedSlowGapATR or nil,
        signalFastSlopeATR=pending ~= nil and pending.signalFastSlopeATR or nil,
        signalMedSlopeATR=pending ~= nil and pending.signalMedSlopeATR or nil,
        signalTriggerBodyATR=pending ~= nil and pending.signalTriggerBodyATR or nil,
        signalTriggerCloseLocation=pending ~= nil and pending.signalTriggerCloseLocation or nil,
        signalSetup=pending ~= nil and pending.entryType or nil,
        entryMLFeatures=pending ~= nil and pending.mlFeatures or nil,
        signalVWAP=pending ~= nil and pending.signalVWAP or nil,
        signalVWAPDistATR=pending ~= nil and pending.signalVWAPDistATR or nil,
        signalFastGapATR=pending ~= nil and pending.signalFastGapATR or nil,
        signalRSI=pending ~= nil and pending.signalRSI or nil,
        signalMomentumATR=pending ~= nil and pending.signalMomentumATR or nil,
        signalADX=pending ~= nil and pending.signalADX or nil,
        signalDIPlus=pending ~= nil and pending.signalDIPlus or nil,
        signalDIMinus=pending ~= nil and pending.signalDIMinus or nil,
        signalSpreadPips=pending ~= nil and pending.signalSpreadPips or nil,
        signalSession=pending ~= nil and pending.signalSession or nil,
        signalHTFTrend=pending ~= nil and pending.signalHTFTrend or nil,
        signalRegimeBest=pending ~= nil and pending.signalRegimeBest or nil,
        signalRegimeSecond=pending ~= nil and pending.signalRegimeSecond or nil,
        signalRegimeMargin=pending ~= nil and pending.signalRegimeMargin or nil,
        scoreTrendUp=pending ~= nil and pending.scoreTrendUp or nil,
        scoreTrendDown=pending ~= nil and pending.scoreTrendDown or nil,
        scoreTrendUpBase=pending ~= nil and pending.scoreTrendUpBase or nil,
        scoreTrendDownBase=pending ~= nil and pending.scoreTrendDownBase or nil,
        scoreRange=pending ~= nil and pending.scoreRange or nil,
        scoreBreakout=pending ~= nil and pending.scoreBreakout or nil,
        scoreReversalBull=pending ~= nil and pending.scoreReversalBull or nil,
        scoreReversalBear=pending ~= nil and pending.scoreReversalBear or nil,
        scoreHighVol=pending ~= nil and pending.scoreHighVol or nil,
        scoreLowVol=pending ~= nil and pending.scoreLowVol or nil,
        signalStructureBias=pending ~= nil and pending.signalStructureBias or nil,
        signalStructureSequence=pending ~= nil and pending.signalStructureSequence or nil,
        signalStructureHighLabel=pending ~= nil and pending.signalStructureHighLabel or nil,
        signalStructureHighValue=pending ~= nil and pending.signalStructureHighValue or nil,
        signalStructureLowLabel=pending ~= nil and pending.signalStructureLowLabel or nil,
        signalStructureLowValue=pending ~= nil and pending.signalStructureLowValue or nil,
        signalStructureBOSUp=pending ~= nil and pending.signalStructureBOSUp or nil,
        signalStructureBOSDown=pending ~= nil and pending.signalStructureBOSDown or nil,
        signalStructureCHOCH=pending ~= nil and pending.signalStructureCHOCH or nil,
        signalStructureCHOCHDirection=pending ~= nil and pending.signalStructureCHOCHDirection or nil,
        signalStructureHighAge=pending ~= nil and pending.signalStructureHighAge or nil,
        signalStructureLowAge=pending ~= nil and pending.signalStructureLowAge or nil,
        signalStructureStale=pending ~= nil and pending.signalStructureStale or nil,
        signalStructureWeightSide=pending ~= nil and pending.signalStructureWeightSide or nil,
        signalStructureWeight=pending ~= nil and pending.signalStructureWeight or nil,
        signalATRBreakHigh=pending ~= nil and pending.signalATRBreakHigh or nil,
        signalATRBreakLow=pending ~= nil and pending.signalATRBreakLow or nil,
        reconciledSameBar=pending ~= nil and pending.reconciledSameBar or false,
        recovered=pending == nil, mfePrice=0, maePrice=0, lastBarsHeld=0
    }
    local entrySign = tradeRow.BS == "B" and 1.0 or -1.0
    if validNumber(openRate) and validNumber(snapshot.signalATR) and snapshot.signalATR > 0 then
        if validNumber(snapshot.signalEMAfast) then
            snapshot.fillPriceToFastEMAATR = entrySign * (openRate - snapshot.signalEMAfast) / snapshot.signalATR
        end
        if validNumber(snapshot.signalEMAmed) then
            snapshot.fillPriceToMedEMAATR = entrySign * (openRate - snapshot.signalEMAmed) / snapshot.signalATR
        end
        if validNumber(snapshot.signalEMAslow) then
            snapshot.fillPriceToSlowEMAATR = entrySign * (openRate - snapshot.signalEMAslow) / snapshot.signalATR
        end
    end
    Rt.tradeAnalytics[tradeId] = snapshot
    Rt.tradeAnalytics[tostring(tradeId)] = snapshot

    local pip = sourcePipSize()
    writeCSVLog("TRADE_OPEN", analyticsMessage({
        {"trade_id", tradeId, 0}, {"side", tradeRow.BS == "B" and "LONG" or "SHORT"},
        {"entry_price", openRate, 5}, {"quantity", quantity, 0},
        {"signal_bar", snapshot.entryPeriod, 0}, {"signal_price", snapshot.signalPrice, 5},
        {"entry_regime", snapshot.entryRegime}, {"entry_engine", snapshot.entryEngine},
        {"entry_base_regime", snapshot.entryBaseRegime},
        {"setup_key", snapshot.setupKey},
        {"setup_anchor", snapshot.setupAnchor, 5}, {"quality", snapshot.score, 2},
        {"required", snapshot.required, 2}, {"initial_stop", initialStop, 5},
        {"initial_target", initialTarget, 5},
        {"initial_risk_price", risk, 5},
        {"initial_risk_pips", validNumber(risk) and risk / pip or nil, 2},
        {"planned_rr", validNumber(targetDistance) and validNumber(risk) and safeDiv(targetDistance, risk, 0) or nil, 2},
        {"session", snapshot.signalSession}, {"htf_trend", snapshot.signalHTFTrend, 0},
        {"regime_best", snapshot.signalRegimeBest, 2},
        {"regime_second", snapshot.signalRegimeSecond, 2},
        {"regime_margin", snapshot.signalRegimeMargin, 2},
        {"atr", snapshot.signalATR, 5}, {"vwap", snapshot.signalVWAP, 5},
        {"vwap_distance_atr", snapshot.signalVWAPDistATR, 3},
        {"fast_ma_gap_atr", snapshot.signalFastGapATR, 3},
        {"entry_setup", snapshot.signalSetup},
        {"price_to_ema_fast_atr", snapshot.signalPriceToFastEMAATR, 3},
        {"price_to_ema_medium_atr", snapshot.signalPriceToMedEMAATR, 3},
        {"price_to_ema_slow_atr", snapshot.signalPriceToSlowEMAATR, 3},
        {"fill_vs_signal_ema_fast_atr", snapshot.fillPriceToFastEMAATR, 3},
        {"fill_vs_signal_ema_medium_atr", snapshot.fillPriceToMedEMAATR, 3},
        {"fill_vs_signal_ema_slow_atr", snapshot.fillPriceToSlowEMAATR, 3},
        {"ema_fast_medium_gap_atr", snapshot.signalFastMedGapATR, 3},
        {"ema_medium_slow_gap_atr", snapshot.signalMedSlowGapATR, 3},
        {"ema_fast_slope_atr", snapshot.signalFastSlopeATR, 3},
        {"ema_medium_slope_atr", snapshot.signalMedSlopeATR, 3},
        {"trigger_body_atr", snapshot.signalTriggerBodyATR, 3},
        {"trigger_close_location", snapshot.signalTriggerCloseLocation, 3},
        {"ai_feature_schema", Const.ML_FEATURE_SCHEMA, 0},
        {"rsi", snapshot.signalRSI, 2}, {"momentum_atr", snapshot.signalMomentumATR, 3},
        {"adx", snapshot.signalADX, 2}, {"di_plus", snapshot.signalDIPlus, 2},
        {"di_minus", snapshot.signalDIMinus, 2}, {"spread_pips", snapshot.signalSpreadPips, 2},
        {"score_trend_up", snapshot.scoreTrendUp, 2},
        {"score_trend_down", snapshot.scoreTrendDown, 2},
        {"score_trend_up_base", snapshot.scoreTrendUpBase, 2},
        {"score_trend_down_base", snapshot.scoreTrendDownBase, 2},
        {"score_range", snapshot.scoreRange, 2}, {"score_breakout", snapshot.scoreBreakout, 2},
        {"score_reversal_bull", snapshot.scoreReversalBull, 2},
        {"score_reversal_bear", snapshot.scoreReversalBear, 2},
        {"score_high_vol", snapshot.scoreHighVol, 2},
        {"score_low_vol", snapshot.scoreLowVol, 2},
        {"structure_bias", snapshot.signalStructureBias},
        {"structure_sequence", snapshot.signalStructureSequence},
        {"structure_last_high_label", snapshot.signalStructureHighLabel},
        {"structure_last_high", snapshot.signalStructureHighValue, 5},
        {"structure_last_low_label", snapshot.signalStructureLowLabel},
        {"structure_last_low", snapshot.signalStructureLowValue, 5},
        {"structure_bos_up", snapshot.signalStructureBOSUp},
        {"structure_bos_down", snapshot.signalStructureBOSDown},
        {"structure_choch", snapshot.signalStructureCHOCH},
        {"structure_choch_direction", snapshot.signalStructureCHOCHDirection},
        {"structure_high_age_bars", snapshot.signalStructureHighAge, 0},
        {"structure_low_age_bars", snapshot.signalStructureLowAge, 0},
        {"structure_stale", snapshot.signalStructureStale},
        {"structure_weight_side", snapshot.signalStructureWeightSide},
        {"structure_weight", snapshot.signalStructureWeight, 2},
        {"pivot_bos_up", snapshot.signalStructureBOSUp},
        {"pivot_bos_down", snapshot.signalStructureBOSDown},
        {"atr_break_high", snapshot.signalATRBreakHigh},
        {"atr_break_low", snapshot.signalATRBreakLow},
        {"same_bar_reconciled", snapshot.reconciledSameBar and "Y" or "N"},
        {"recovered", snapshot.recovered and "Y" or "N"}
    }), snapshot.entryTime)
    Rt.emitOpenConfirmed(tradeRow, pending, risk, initialStop, initialTarget, quantity, openRate)
    return snapshot
end

local function professionalTradeClose(item, classification)
    local tradeId = item.tradeId
    local snapshot = tradeId ~= nil
        and (Rt.tradeAnalytics[tradeId] or Rt.tradeAnalytics[tostring(tradeId)]) or nil
    local entryPrice = snapshot ~= nil and snapshot.entryPrice or item.openPrice
    local exitPrice = item.closeQuantity > 0 and item.closeValue / item.closeQuantity or nil
    local side = snapshot ~= nil and snapshot.side or item.side
    if classification == "LOSS" and (side == "B" or side == "S") then
        local barsHeld = snapshot ~= nil and tonumber(snapshot.lastBarsHeld) or nil
        if (barsHeld == nil or barsHeld <= 0) and snapshot ~= nil
            and validNumber(Rt.processingPeriod) and validNumber(snapshot.entryPeriod) then
            barsHeld = max(0, Rt.processingPeriod - snapshot.entryPeriod)
        end
        Rt.lastLoss = {side=side,
            bars=validNumber(barsHeld) and barsHeld or 999,
            period=Rt.processingPeriod}
    end
    local risk = snapshot ~= nil and snapshot.initialRisk or nil
    local priceResult = nil
    if validNumber(entryPrice) and validNumber(exitPrice) then
        priceResult = side == "B" and (exitPrice - entryPrice) or (entryPrice - exitPrice)
    end
    local priceR = validNumber(priceResult) and validNumber(risk) and risk > 0
        and priceResult / risk or nil
    if snapshot ~= nil and validNumber(priceResult) then
        if priceResult >= 0 then snapshot.mfePrice = max(snapshot.mfePrice or 0, priceResult)
        else snapshot.maePrice = max(snapshot.maePrice or 0, -priceResult) end
    end
    local lots = validNumber(item.quantity) and validNumber(Rt.BaseSize) and Rt.BaseSize > 0
        and item.quantity / Rt.BaseSize or nil
    local pipValue = Rt.EffectivePipValuePerBaseUnit
    local cashRisk = validNumber(risk) and risk > 0 and validNumber(pipValue) and pipValue > 0
        and validNumber(lots) and (risk / sourcePipSize()) * pipValue * lots or nil
    local netR = validNumber(cashRisk) and cashRisk > 0 and item.pl / cashRisk or nil
    local reason = tradeId ~= nil
        and (Rt.tradeExitReasons[tradeId] or Rt.tradeExitReasons[tostring(tradeId)]) or nil
    -- A stop edit can be confirmed asynchronously after the final closed-bar
    -- TRADE_UPDATE and before the trade closes. Publish the newest confirmed
    -- broker stop first so TRADE_CLOSE never falls back to a stale bar snapshot.
    local latestConfirmedStop = nil
    if tradeId ~= nil then
        latestConfirmedStop = Rt.brokerStopRates[tradeId]
            or Rt.brokerStopRates[tostring(tradeId)]
    end
    if not validNumber(latestConfirmedStop) and snapshot ~= nil then
        latestConfirmedStop = snapshot.lastBrokerStop or snapshot.initialStop
    end
    if reason == nil and snapshot ~= nil and validNumber(exitPrice) then
        local tolerance = sourcePipSize() * 2
        local stop = latestConfirmedStop
        local target = snapshot.initialTarget
        if validNumber(stop) and ((side == "B" and exitPrice <= stop + tolerance)
            or (side == "S" and exitPrice >= stop - tolerance)) then
            reason = "broker stop or trail"
        elseif validNumber(target) and ((side == "B" and exitPrice >= target - tolerance)
            or (side == "S" and exitPrice <= target + tolerance)) then
            reason = "broker target"
        end
    end
    if reason == nil then reason = "broker/manual/unknown" end

    -- The learning input and reported probability remain the last reliable
    -- managed-bar observation. Final fills and excursions below are audit
    -- fields only: feeding them back into the sample would leak its outcome
    -- and teach a different feature distribution from open-trade prediction.

    -- Close accounting is deliberately allowed before indicator readiness.
    -- Never label a close with stale prior-bar Context: prefer the trade's last
    -- managed snapshot, otherwise use current Context only when this bar has
    -- successfully completed updateMarketContext().
    local contextReliable = Rt.contextReadyForBar == true
    local exitStructureCHOCH = contextReliable and Context.marketStructureCHOCH or nil
    local exitStructureStale = contextReliable and Context.marketStructureStale or nil
    local exitStructureBOSUp = contextReliable and Context.marketStructureBOSUp or nil
    local exitStructureBOSDown = contextReliable and Context.marketStructureBOSDown or nil
    if snapshot ~= nil then
        if snapshot.lastStructureCHOCH ~= nil then exitStructureCHOCH = snapshot.lastStructureCHOCH end
        if snapshot.lastStructureStale ~= nil then exitStructureStale = snapshot.lastStructureStale end
        if snapshot.lastStructureBOSUp ~= nil then exitStructureBOSUp = snapshot.lastStructureBOSUp end
        if snapshot.lastStructureBOSDown ~= nil then exitStructureBOSDown = snapshot.lastStructureBOSDown end
    end
    local hasExitStructureCHOCH = snapshot ~= nil and snapshot.lastStructureCHOCH ~= nil or contextReliable
    local hasExitStructureStale = snapshot ~= nil and snapshot.lastStructureStale ~= nil or contextReliable
    local hasExitStructureBOSUp = snapshot ~= nil and snapshot.lastStructureBOSUp ~= nil or contextReliable
    local hasExitStructureBOSDown = snapshot ~= nil and snapshot.lastStructureBOSDown ~= nil or contextReliable

    writeCSVLog("TRADE_CLOSE", analyticsMessage({
        {"trade_id", tradeId or item.id, 0}, {"side", side == "B" and "LONG" or "SHORT"},
        {"entry_price", entryPrice, 5}, {"exit_price", exitPrice, 5},
        {"quantity", item.quantity, 0}, {"net_pl", item.pl, 2},
        {"gross_pl", item.gross, 2}, {"commission", item.commission, 2},
        {"interest", item.interest, 2}, {"classification", classification},
        {"exit_reason", reason}, {"price_result", priceResult, 5},
        {"price_r", priceR, 3}, {"net_r", netR, 3},
        {"bars_held", snapshot ~= nil and snapshot.lastBarsHeld or nil, 0},
        {"mfe_price", snapshot ~= nil and snapshot.mfePrice or nil, 5},
        {"mae_price", snapshot ~= nil and snapshot.maePrice or nil, 5},
        {"mfe_pips", snapshot ~= nil and snapshot.mfePrice / sourcePipSize() or nil, 2},
        {"mae_pips", snapshot ~= nil and snapshot.maePrice / sourcePipSize() or nil, 2},
        {"mfe_r", snapshot ~= nil and validNumber(risk) and risk > 0 and snapshot.mfePrice / risk or nil, 3},
        {"mae_r", snapshot ~= nil and validNumber(risk) and risk > 0 and snapshot.maePrice / risk or nil, 3},
        {"entry_regime", snapshot ~= nil and snapshot.entryRegime or nil},
        {"entry_base_regime", snapshot ~= nil and snapshot.entryBaseRegime or nil},
        {"setup_key", snapshot ~= nil and snapshot.setupKey or nil},
        {"entry_setup", snapshot ~= nil and snapshot.signalSetup or nil},
        {"entry_price_vs_ema_fast_atr", snapshot ~= nil and snapshot.signalPriceToFastEMAATR or nil, 3},
        {"entry_price_vs_ema_medium_atr", snapshot ~= nil and snapshot.signalPriceToMedEMAATR or nil, 3},
        {"entry_price_vs_ema_slow_atr", snapshot ~= nil and snapshot.signalPriceToSlowEMAATR or nil, 3},
        {"entry_fill_vs_signal_ema_fast_atr", snapshot ~= nil and snapshot.fillPriceToFastEMAATR or nil, 3},
        {"entry_fill_vs_signal_ema_medium_atr", snapshot ~= nil and snapshot.fillPriceToMedEMAATR or nil, 3},
        {"entry_fill_vs_signal_ema_slow_atr", snapshot ~= nil and snapshot.fillPriceToSlowEMAATR or nil, 3},
        {"ai_feature_schema", Const.ML_FEATURE_SCHEMA, 0},
        {"ai_exit_feature_schema", Const.ML_EXIT_FEATURE_SCHEMA, 0},
        {"ai_exit_prediction_probability", snapshot ~= nil and snapshot.exitAIProbability or nil, 4},
        {"ai_exit_prediction_samples", snapshot ~= nil and snapshot.exitAISamples or nil, 0},
        {"quality", snapshot ~= nil and snapshot.score or nil, 2},
        {"required", snapshot ~= nil and snapshot.required or nil, 2},
        {"exit_regime", snapshot ~= nil and snapshot.lastRegime or (contextReliable and Rt.currentRegime or nil)},
        {"exit_base_regime", snapshot ~= nil and snapshot.lastBaseRegime or (contextReliable and Rt.currentBaseRegime or nil)},
        {"entry_structure", snapshot ~= nil and snapshot.signalStructureBias or nil},
        {"entry_structure_sequence", snapshot ~= nil and snapshot.signalStructureSequence or nil},
        {"exit_structure", snapshot ~= nil and snapshot.lastStructureBias or (contextReliable and Context.marketStructureBias or nil)},
        {"exit_structure_sequence", snapshot ~= nil and snapshot.lastStructureSequence or (contextReliable and Context.marketStructureSequence or nil)},
        {"exit_structure_choch", hasExitStructureCHOCH and yn(exitStructureCHOCH) or "NA"},
        {"exit_structure_stale", hasExitStructureStale and yn(exitStructureStale) or "NA"},
        {"exit_pivot_bos_up", hasExitStructureBOSUp and yn(exitStructureBOSUp) or "NA"},
        {"exit_pivot_bos_down", hasExitStructureBOSDown and yn(exitStructureBOSDown) or "NA"},
        {"exit_reference", "last_managed_closed_bar"},
        {"exit_fill_vs_last_ema_fast_atr", snapshot ~= nil and validNumber(exitPrice)
            and validNumber(snapshot.lastManagedATR) and snapshot.lastManagedATR > 0
            and validNumber(snapshot.lastManagedEMAfast)
            and (side == "B" and 1 or -1) * (exitPrice - snapshot.lastManagedEMAfast) / snapshot.lastManagedATR or nil, 3},
        {"exit_fill_vs_last_ema_medium_atr", snapshot ~= nil and validNumber(exitPrice)
            and validNumber(snapshot.lastManagedATR) and snapshot.lastManagedATR > 0
            and validNumber(snapshot.lastManagedEMAmed)
            and (side == "B" and 1 or -1) * (exitPrice - snapshot.lastManagedEMAmed) / snapshot.lastManagedATR or nil, 3},
        {"exit_fill_vs_last_ema_slow_atr", snapshot ~= nil and validNumber(exitPrice)
            and validNumber(snapshot.lastManagedATR) and snapshot.lastManagedATR > 0
            and validNumber(snapshot.lastManagedEMAslow)
            and (side == "B" and 1 or -1) * (exitPrice - snapshot.lastManagedEMAslow) / snapshot.lastManagedATR or nil, 3},
        {"last_managed_close_vs_ema_fast_atr", snapshot ~= nil and snapshot.lastPriceToFastEMAATR or nil, 3},
        {"last_managed_close_vs_ema_medium_atr", snapshot ~= nil and snapshot.lastPriceToMedEMAATR or nil, 3},
        {"last_managed_close_vs_ema_slow_atr", snapshot ~= nil and snapshot.lastPriceToSlowEMAATR or nil, 3},
        {"last_managed_ema_fast_medium_gap_atr", snapshot ~= nil and snapshot.lastFastMedGapATR or nil, 3},
        {"last_managed_ema_medium_slow_gap_atr", snapshot ~= nil and snapshot.lastMedSlowGapATR or nil, 3},
        {"last_managed_ema_fast_slope_atr", snapshot ~= nil and snapshot.lastFastSlopeATR or nil, 3},
        {"last_managed_ema_medium_slope_atr", snapshot ~= nil and snapshot.lastMedSlopeATR or nil, 3},
        {"last_managed_ema_stack", snapshot ~= nil and snapshot.lastEMAStack or nil},
        {"last_managed_vwap_distance_atr", snapshot ~= nil and snapshot.lastVWAPDistATR or nil, 3},
        {"same_bar_reconciled", snapshot ~= nil and snapshot.reconciledSameBar and "Y" or "N"},
        {"last_stop", latestConfirmedStop, 5},
        {"excursion_scope", "closed executable bars plus exit price"},
        {"recovered", snapshot ~= nil and snapshot.recovered and "Y" or "N"}
    }), item.time)

    if tradeId ~= nil then
        if snapshot ~= nil and snapshot.tradeId ~= nil then
            Rt.tradeAnalytics[snapshot.tradeId] = nil
            Rt.tradeExitReasons[snapshot.tradeId] = nil
        end
        Rt.tradeAnalytics[tradeId] = nil
        Rt.tradeAnalytics[tostring(tradeId)] = nil
        Rt.tradeExitReasons[tradeId] = nil
        Rt.tradeExitReasons[tostring(tradeId)] = nil
    end
    return netR
end

local function pendingOpenMatchesClosedTrade(pending, item)
    if pending == nil or item == nil or pending.side ~= item.side then return false end
    if pending.period == nil or Rt.processingPeriod == nil then return false end
    local age = Rt.processingPeriod - pending.period
    if age < 0 or age > Cfg.PendingOpenTimeoutBars then return false end

    -- When both timestamps are exposed by the host, reject a stale/foreign
    -- closed row even if it happens to have the same side. Indicore dates are
    -- expressed in days; allow one minute of timestamp rounding at the start.
    if validNumber(pending.submittedAt) and validNumber(item.openTime) then
        local barMinutes = timeframeMinutes(Cfg.TF) or 1
        local earliest = pending.submittedAt - (1 / 1440.0)
        local latest = pending.submittedAt
            + ((Cfg.PendingOpenTimeoutBars + 1) * barMinutes / 1440.0)
        if item.openTime < earliest or item.openTime > latest then return false end
    end
    return true
end

local function reconcilePendingOpenFromClosedTrade(item)
    if item == nil or item.tradeId == nil then return nil end

    local pending, requestId = nil, nil
    if item.openOrderReqID ~= nil then
        local exactId = tostring(item.openOrderReqID)
        local exact = Rt.pendingOpenRequests[exactId]
        if pendingOpenMatchesClosedTrade(exact, item) then
            pending, requestId = exact, exactId
        end
    end

    -- Some TS2 closed-trade rows omit OpenOrderReqID. Because new entries are
    -- blocked while any open request is pending, exactly one recent same-side
    -- candidate is an unambiguous fallback. Never guess when several match.
    if pending == nil then
        local candidate, candidateId, count = nil, nil, 0
        for id, value in pairs(Rt.pendingOpenRequests) do
            if pendingOpenMatchesClosedTrade(value, item) then
                candidate, candidateId, count = value, id, count + 1
            end
        end
        if count == 1 then pending, requestId = candidate, candidateId end
    end
    if pending == nil and pendingOpenMatchesClosedTrade(Rt.pendingUnknownOpen, item) then
        pending = Rt.pendingUnknownOpen
    end
    if pending == nil then return nil end

    -- The order really filled, so clear only the pending-request machinery.
    -- Do not call releaseUnfilledOpenState(): cooldown and setup reuse state
    -- must remain exactly as they would for any other filled trade.
    if requestId ~= nil then Rt.pendingOpenRequests[requestId] = nil end
    if Rt.pendingUnknownOpen == pending then Rt.pendingUnknownOpen = nil end
    forgetOpenCookiesForPending(pending)

    pending.reconciledSameBar = true
    local tradeId = item.tradeId
    Rt.tradeRecovered[tradeId] = false
    if validNumber(pending.risk) and pending.risk > 0 then
        Rt.tradeInitialRisk[tradeId] = pending.risk
    end
    Rt.tradeEntryRegime[tradeId] = pending.regime
    Rt.tradeEntryEngine[tradeId] = pending.entryEngine or "UNKNOWN"
    Rt.tradeSetupAnchor[tradeId] = pending.setupAnchor
    if pending.mlFeatures ~= nil then
        Rt.tradeMLFeatures[tradeId] = pending.mlFeatures
        Rt.tradeMLFeatures[tostring(tradeId)] = pending.mlFeatures
    end
    persistTradeMetadata(tradeId)

    local syntheticTrade = {
        TradeID=tradeId, BS=item.side, Lot=item.quantity,
        Open=item.openPrice, Time=item.openTime or pending.submittedAt
    }
    local snapshot = tradeAnalyticsSnapshot(syntheticTrade, pending, pending.risk)
    snapshot.lastRegime = Rt.currentRegime
    snapshot.lastBaseRegime = Rt.currentBaseRegime
    snapshot.lastStructureBias = Context.marketStructureBias
    snapshot.lastStructureSequence = Context.marketStructureSequence
    snapshot.lastStructureCHOCH = Context.marketStructureCHOCH
    snapshot.lastStructureStale = Context.marketStructureStale
    snapshot.lastStructureBOSUp = Context.marketStructureBOSUp
    snapshot.lastStructureBOSDown = Context.marketStructureBOSDown
    debug("SAME-BAR TRADE RECONCILED | TradeID=" .. tostring(tradeId)
        .. " request=" .. tostring(requestId or "UNKNOWN")
        .. " barsHeld=0")
    return snapshot
end

local function refreshClosedTradeLosses()
    if not Cfg.AllowTrade then
        Rt.sessionRiskReady = true
        return
    end
    local wasReady = Rt.sessionRiskReady
    Rt.sessionRiskReady = false
    local ok, err = pcall(function()
        if not checkReady("closed trades") then return end
        local tableRef = core.host:findTable("closed trades")
        if tableRef == nil then return end
        local enum = tableRef:enumerator()
        local row = enum:next()
        local closedRows = {}
        local lineageParent = {}
        local accountSessionNetPL = 0
        while row ~= nil do
            -- Account is the cheapest/highest-selectivity filter. Avoid two
            -- host timezone conversions for every unrelated account row.
            if row.AccountID == Rt.Account then
                local closeTime = row.CloseTime or row.OpenTime
                if closeTime ~= nil then
                    if getDayKey(closeTime) == Rt.sessionKey then
                        accountSessionNetPL = accountSessionNetPL + closedTradeNetPL(row)
                    end
                    -- Only this strategy's rows need the separate UTC-day
                    -- conversion used to reconstruct the loss streak.
                    if row.OfferID == Rt.Offer and closedTradeCustomID(row) == Cfg.CustomID then
                        local tradeId = nonEmptyString(row.TradeID)
                        local origin = nonEmptyString(row.TradeIDOrigin)
                        local remain = nonEmptyString(row.TradeIDRemain)
                        if tradeId ~= nil and origin ~= nil then lineageParent[tradeId] = origin end
                        if tradeId ~= nil and remain ~= nil then lineageParent[remain] = tradeId end
                        closedRows[#closedRows + 1] = {
                            tradeId=tradeId, fallbackId=closedTradeEventID(row),
                            pl=closedTradeNetPL(row), time=closeTime,
                            openTime=tonumber(row.OpenTime or row.Time),
                            openOrderReqID=nonEmptyString(row.OpenOrderReqID),
                            gross=tonumber(row.GrossPL) or 0,
                            commission=tonumber(row.Com) or 0,
                            interest=tonumber(row.Int) or 0,
                            quantity=abs(tonumber(row.Lot) or 0),
                            openPrice=tonumber(row.Open), closePrice=tonumber(row.Close),
                            side=row.BS
                        }
                    end
                end
            end
            row = enum:next()
        end

        local balance = getAccountBalance()
        if balance == nil then return end
        local reconstructedBaseline = balance - accountSessionNetPL
        if not wasReady then
            -- Reconstruct the session-opening account value from BALANCE, not
            -- current equity. Equity includes floating P/L, which can make a
            -- restart silently lower the reconstructed baseline and weaken the
            -- daily-loss cap. Later cash flow is detected and rebased below;
            -- if Balance is unavailable, risk state remains blocked.
            Rt.sessionStartEquity = reconstructedBaseline
            runtimePut("riskSessionKey", Rt.sessionKey)
            runtimePut("riskSessionStartEquity", string.format("%.17g", Rt.sessionStartEquity))
        elseif validNumber(reconstructedBaseline) and reconstructedBaseline > 0
            and abs(reconstructedBaseline - Rt.sessionStartEquity) > Const.LOSS_EPSILON then
            -- Balance minus realized session P/L changes only when external cash
            -- flow (deposit/withdrawal/transfer) changes the account baseline.
            -- Rebase by that amount so cash movement is not classified as
            -- strategy drawdown or used to mask it.
            debug(string.format("SESSION BASELINE CASH-FLOW ADJUSTMENT | %.2f -> %.2f",
                Rt.sessionStartEquity, reconstructedBaseline))
            Rt.sessionStartEquity = reconstructedBaseline
            runtimePut("riskSessionStartEquity", string.format("%.17g", Rt.sessionStartEquity))
        end

        local unseen = {}
        local openTradeIds = {}
        local tradesReady = checkReady("trades")
        if tradesReady then
            local trades = core.host:findTable("trades")
            if trades == nil then tradesReady = false end
            if trades ~= nil then
                local tradeEnum = trades:enumerator()
                local tradeRow = tradeEnum:next()
                while tradeRow ~= nil do
                    if tradeRow.AccountID == Rt.Account and tradeRow.OfferID == Rt.Offer
                        and tradeRow.QTXT == Cfg.CustomID and tradeRow.TradeID ~= nil then
                        local openId = tostring(tradeRow.TradeID)
                        openTradeIds[openId] = true
                        local origin = nonEmptyString(tradeRow.TradeIDOrigin)
                        if origin ~= nil then lineageParent[openId] = origin end
                    end
                    tradeRow = tradeEnum:next()
                end
            end
        end
        local function lineageRoot(id)
            if id == nil then return nil end
            local current = id
            local seen = {}
            for _ = 1, 100 do
                if seen[current] then break end
                seen[current] = true
                local parent = lineageParent[current]
                if parent == nil or parent == "" then break end
                current = parent
            end
            return current
        end
        local function reconcileClosedLineage(root)
            if root == nil then return end
            clearReconciledCloseState(root, nil)
            local tracked = {}
            local maps = {Rt.tradeInitialRisk, Rt.tradeEntryRegime, Rt.tradeEntryEngine, Rt.tradeAnalytics,
                Rt.closePendingTradeIds, Rt.tradeExitReasons, Rt.awaitingCloseReconciliation}
            for i = 1, #maps do
                for candidateId, _ in pairs(maps[i]) do tracked[tostring(candidateId)] = true end
            end
            for candidateId, _ in pairs(tracked) do
                if lineageRoot(candidateId) == root then
                    clearReconciledCloseState(candidateId, nil)
                    if candidateId ~= root then
                        Rt.knownClosedTrades["TRADE:" .. candidateId] = true
                    end
                end
            end
        end

        local completed = {}
        for i = 1, #closedRows do
            local sourceItem = closedRows[i]
            local root = lineageRoot(sourceItem.tradeId)
            local id = root ~= nil and ("TRADE:" .. root) or sourceItem.fallbackId
            local item = completed[id]
            if item == nil then
                item = {id=id, tradeId=root, pl=0, gross=0, commission=0, interest=0,
                    quantity=0, closeQuantity=0, closeValue=0,
                    openPrice=sourceItem.openPrice, openTime=sourceItem.openTime,
                    openOrderReqID=sourceItem.openOrderReqID,
                    side=sourceItem.side, time=sourceItem.time}
                completed[id] = item
            end
            item.pl = item.pl + sourceItem.pl
            item.gross = item.gross + sourceItem.gross
            item.commission = item.commission + sourceItem.commission
            item.interest = item.interest + sourceItem.interest
            item.quantity = item.quantity + sourceItem.quantity
            if validNumber(sourceItem.closePrice) and sourceItem.quantity > 0 then
                item.closeValue = item.closeValue + sourceItem.closePrice * sourceItem.quantity
                item.closeQuantity = item.closeQuantity + sourceItem.quantity
            end
            if not validNumber(item.openPrice) and validNumber(sourceItem.openPrice) then
                item.openPrice = sourceItem.openPrice
            end
            if not validNumber(item.openTime) and validNumber(sourceItem.openTime) then
                item.openTime = sourceItem.openTime
            end
            if item.openOrderReqID == nil and sourceItem.openOrderReqID ~= nil then
                item.openOrderReqID = sourceItem.openOrderReqID
            end
            if item.side == nil then item.side = sourceItem.side end
            if sourceItem.time > item.time then item.time = sourceItem.time end
        end

        local openRoots = {}
        for openId, _ in pairs(openTradeIds) do
            openRoots[lineageRoot(openId)] = true
        end

        -- A restart begins with an empty in-memory de-duplication set while
        -- the broker's closed-trades table still contains today's completed
        -- history. Wait for the open-trades table as well, then use this first
        -- reliable scan as the accounting baseline. Baseline rows rebuild the
        -- consecutive-loss state below but must not be emitted or learned a
        -- second time. A pending/snapshotted close created by this instance is
        -- still published, including a fill-and-stop on its first scan.
        if not tradesReady then return end
        local baselinePass = not Rt.closedHistoryInitialized
        Rt.closedHistoryInitialized = true

        for id, item in pairs(completed) do
            local fullyClosed = item.tradeId == nil
                or (tradesReady and not openRoots[item.tradeId])
            if fullyClosed then reconcileClosedLineage(item.tradeId) end
            if not Rt.knownClosedTrades[id]
                -- The trade belongs to the UTC day in which its FINAL close
                -- occurred, but its P/L includes every available partial-close
                -- row, including portions realized before midnight.
                and getUTCDayKey(item.time) == Rt.lossStreakUTCKey
                and fullyClosed then
                unseen[#unseen + 1] = item
            end
        end

        table.sort(unseen, function(a, b)
            if a.time == b.time then return a.id < b.id end
            return a.time < b.time
        end)
        local baselineSuppressed = 0
        for i = 1, #unseen do
            Rt.knownClosedTrades[unseen[i].id] = true
            local pl = unseen[i].pl
            if validNumber(pl) then
                local classification = "BREAK_EVEN"
                if pl < -Const.LOSS_EPSILON then
                    Rt.consecutiveLosses = Rt.consecutiveLosses + 1
                    classification = "LOSS"
                elseif pl > Const.LOSS_EPSILON then
                    Rt.consecutiveLosses = 0
                    classification = "WIN"
                elseif Cfg.BreakEvenResetsLossStreak then
                    -- Explicit v9.2.14 policy: a confirmed non-loss can interrupt
                    -- the consecutive-loss sequence. OFF preserves legacy behavior.
                    Rt.consecutiveLosses = 0
                end
                local tradeId = unseen[i].tradeId
                -- Restore restart-safe entry and latest managed-exit context
                -- before deciding whether this confirmed result is eligible
                -- for Smart AI learning.
                if tradeId ~= nil then loadTradeMetadata(tradeId) end
                local hadActiveContext = tradeId ~= nil and (
                    Rt.tradeAnalytics[tradeId] ~= nil
                    or Rt.tradeAnalytics[tostring(tradeId)] ~= nil
                    or Rt.tradeMLFeatures[tradeId] ~= nil
                    or Rt.tradeMLFeatures[tostring(tradeId)] ~= nil
                    or Rt.tradeExitFeatures[tradeId] ~= nil
                    or Rt.tradeExitFeatures[tostring(tradeId)] ~= nil
                    or Rt.tradeExitReasons[tradeId] ~= nil
                    or Rt.tradeExitReasons[tostring(tradeId)] ~= nil)
                local reconciled = reconcilePendingOpenFromClosedTrade(unseen[i])
                local publishClose = not baselinePass or hadActiveContext or reconciled ~= nil
                if baselinePass and Rt.processingPeriod ~= nil then
                    local currentDate = closedBarEndDate(Rt.processingPeriod)
                        or Rt.Source:date(Rt.processingPeriod)
                    local recoveredClosePeriod = restoreRecentPeriod(unseen[i].time, currentDate,
                        Rt.processingPeriod, max(1, Cfg.MinBarsBetweenTrades + 1))
                    if recoveredClosePeriod ~= nil and (Rt.lastTradeClosePeriod == nil
                        or recoveredClosePeriod > Rt.lastTradeClosePeriod) then
                        Rt.lastTradeClosePeriod = recoveredClosePeriod
                        persistEntryRuntimeState()
                    end
                end
                if publishClose then
                    -- Start the shared entry cooldown only after the broker's
                    -- closed-trades table confirms that the strategy trade is
                    -- completely closed. A submitted/pending close is not enough.
                    Rt.lastTradeClosePeriod = Rt.processingPeriod
                    persistEntryRuntimeState()
                    local netR = professionalTradeClose(unseen[i], classification)
                    local closeConfirmedText = string.format(
                        "%s | CLOSE_CONFIRMED TradeID=%s event=%s netPL=%.2f class=%s cooldownStartBar=%s cooldown=%d bars",
                        STRATEGY_NAME, tostring(tradeId or "NA"), tostring(unseen[i].id), pl, classification,
                        tostring(Rt.lastTradeClosePeriod or "NA"), Cfg.MinBarsBetweenTrades)
                    writeCSVLog("CLOSE_CONFIRMED", closeConfirmedText, unseen[i].time)
                    if Cfg.ShowCleanDiagnostics or Cfg.ShowDebug then emitTerminalDiagnostic(closeConfirmedText)
                    elseif Cfg.ShowAlerts then alert(closeConfirmedText) end
                    -- ML is downstream of the deterministic accounting above.
                    -- A missing/recovered feature snapshot simply skips learning;
                    -- it can never change loss-streak or daily-risk state.
                    local mlOK, mlErr = pcall(function()
                        local exitLearned = SmartAI.learnExitClosedTrade(tradeId, pl, unseen[i].id)
                        SmartAI.learnClosedTrade(tradeId, pl, unseen[i].id, netR)
                        if exitLearned then
                            debug(string.format("SMART AI EXIT CLOSE LINKED | TradeID=%s event=%s netR=%s",
                                tostring(tradeId), tostring(unseen[i].id), tostring(netR or "NA")))
                        end
                    end)
                    if not mlOK then
                        alert("ML UPDATE FAILED: deterministic close accounting preserved | " .. tostring(mlErr))
                    end
                    debug(string.format("CLOSED RESULT | event=%s netPL=%.2f class=%s consecutiveLosses=%d/%d",
                        unseen[i].id, pl, classification,
                        Rt.consecutiveLosses, Cfg.MaxConsecutiveLosses))
                else
                    baselineSuppressed = baselineSuppressed + 1
                end
            end
        end
        if baselinePass and baselineSuppressed > 0 then
            debug(string.format("CLOSED HISTORY BASELINE | seeded=%d analyticsSuppressed=%d consecutiveLosses=%d/%d",
                #unseen, baselineSuppressed, Rt.consecutiveLosses, Cfg.MaxConsecutiveLosses))
        end
        Rt.sessionRiskReady = Rt.sessionStartEquity ~= nil and Rt.sessionStartEquity > 0
    end)
    if not ok then
        Rt.sessionRiskReady = false
        debug("Closed-trade loss state unavailable: " .. tostring(err))
    end
end

local function checkRiskLimits()
    Rt.moneyBudget = nil
    if not Cfg.AllowTrade then return true, "signal-only mode" end
    if Rt.LegacyCustomIDMode then return false, "legacy shared CustomID: manage-only; restart with a unique ID" end
    if not Rt.sessionRiskReady then return false, "daily risk state not ready" end
    if hasPendingOpenRequest() then return false, "open order pending" end
    if hasPendingCloseRequest() then return false, "position close pending" end
    if Rt.moneyGuardEnabled() then
        local pipValue, pipReason = Rt.resolvePipValue()
        if not validNumber(pipValue) or pipValue <= 0 then
            return false, "monetary risk guard: pip value unavailable: " .. tostring(pipReason)
        end
    end
    if currentStrategyUnits() >= Cfg.MaxTotalUnits then return false, "total strategy exposure cap" end
    local openCount = ownTradesCount(nil)
    if not Rt.CanClose and openCount >= 1 then return false, "FIFO safety cap: one strategy position" end
    if (not Cfg.AllowMultiple) and openCount >= 1 then return false, "position cap (Allow Multiple=No)" end
    if Cfg.AllowMultiple and openCount >= Cfg.MaxPositions then return false, "position cap" end
    if Rt.consecutiveLosses >= Cfg.MaxConsecutiveLosses then return false, "consecutive-loss cap" end
    local eq = getAccountEquity()
    -- Fail closed. Fixed-lot mode must not bypass the daily-loss cap merely
    -- because the accounts table/equity field is temporarily unavailable.
    if not validNumber(eq) or eq <= 0 then return false, "current account equity unavailable" end
    if Rt.sessionStartEquity == nil or Rt.sessionStartEquity <= 0 then return false, "session equity baseline unavailable" end
    local ddPct = (Rt.sessionStartEquity - eq) / Rt.sessionStartEquity * 100
    if ddPct >= Cfg.MaxDailyLossPct then
        Rt.dailyLossLocked = true
        runtimePut("dailyLossLockSession", Rt.sessionKey or "")
    end
    if Rt.dailyLossLocked then return false, "daily equity loss cap latched until next session" end
    if Rt.moneyGuardEnabled() then
        local budget, reason = Rt.availableRiskBudget(1)
        if budget == nil or budget <= 0 then return false, "risk capacity: " .. tostring(reason) end
    end
    return true, "OK"
end

-- =========================
-- Execution
-- =========================
local function marketOrder(side, units, stopDistance, targetDistance, p, setupKey, setupAnchor, mlDecision,
    entryScore, entryRequired, entryRegime, riskScore, riskRequired, entryType, entryEngine)
    local orderRegime = entryRegime or Rt.currentRegime
    if mlDecision ~= nil and mlDecision.block == true then
        alert("OPEN BLOCKED: Smart AI veto remains active")
        return false
    end
    if not Cfg.AllowTrade then
        alert("SIGNAL ONLY: " .. side .. " " .. tostring(orderRegime))
        return true, stopDistance / sourcePipSize(), targetDistance / sourcePipSize(), units, nil, nil
    end
    if not validNumber(units) or units <= 0 or (side ~= "B" and side ~= "S") then return false end
    local riskOK, riskReason = checkRiskLimits()
    if not riskOK then alert("OPEN BLOCKED: " .. tostring(riskReason)); return false end
    local liveSpread = spreadPips()
    if liveSpread > Cfg.MaxSpreadPips then
        alert(string.format("OPEN BLOCKED: live spread %.2fp exceeds %.2fp", liveSpread, Cfg.MaxSpreadPips))
        return false
    end
    if Cfg.ExecutionQualityMode == "FILTER" then
        local q = Rt.executionQuality
        local costOK, costReason = Rt.executionCostStatus(liveSpread, Context.atr,
            q ~= nil and q.reference or nil, q ~= nil and q.samples or 0)
        if not costOK then
            alert("OPEN BLOCKED: live execution quality: " .. costReason)
            return false
        end
    end
    local netConflict, netReason = entryPositionConflict(side)
    if netConflict then
        alert("OPEN BLOCKED: account-position conflict: " .. tostring(netReason))
        return false
    end

    local pip = sourcePipSize()
    local plannedStopDistance, plannedTargetDistance, plannedUnits = stopDistance, targetDistance, units
    stopDistance, targetDistance = Rt.orderDistances(orderRegime, stopDistance, targetDistance, liveSpread)
    if stopDistance == nil then alert("OPEN BLOCKED: invalid stop/target geometry"); return false end
    local stopPips, targetPips = stopDistance / pip, targetDistance / pip

    -- Re-read equity/exposure immediately before submission; live-spread stop
    -- floors can widen the stop after the closed-bar plan was sized. Affordability
    -- is evaluated BEFORE strategy-fit geometry vetoes so diagnostics distinguish
    -- money constraints from market-geometry constraints.
    local checkedUnits = calculatePositionSize(stopDistance, orderRegime,
        riskScore or entryScore, riskRequired or entryRequired)
    units = min(units, checkedUnits)
    Rt.emitStopPreflight(p, side, orderRegime, plannedStopDistance, plannedTargetDistance,
        plannedUnits, stopDistance, targetDistance, units, liveSpread)
    local preflightRiskText = Rt.cleanRiskFitText(stopDistance, units)
    writeCSVLog("RISK_FIT_PREFLIGHT", preflightRiskText, closedBarEndDate(p) or Rt.Source:date(p))
    if units < Rt.BaseSize then
        alert("OPEN BLOCKED: " .. Rt.riskBlockLabel(stopDistance, units) .. " | " .. tostring(Rt.lastSizingReason or "size below broker minimum"))
        return false
    end

    local geometryOK, geometryReason = Rt.stopGeometryStatus(stopDistance)
    if not geometryOK then
        alert("OPEN BLOCKED: " .. geometryReason)
        return false
    end
    if orderRegime == "CHOPPY_RANGE" then
        local rangeOK, rangeReason, rangeText = Rt.rangeGeometryStatus(side, p, stopDistance, targetDistance)
        writeCSVLog("RANGE_GEOMETRY_PREFLIGHT", rangeText, closedBarEndDate(p) or Rt.Source:date(p))
        if not rangeOK then
            alert("OPEN BLOCKED: " .. rangeReason)
            return false
        end
    end

    if Rt.moneyGuardEnabled() then
        local cashRisk = Rt.riskCashPerLot(stopDistance)
        local pipValue = Rt.EffectivePipValuePerBaseUnit
        local cashReward = validNumber(pipValue) and targetPips * pipValue - Rt.riskCashPerLot(0) or nil
        if not validNumber(cashRisk) or cashRisk <= 0 or cashReward / cashRisk < Cfg.MinNetRewardRisk then
            alert("OPEN BLOCKED: planned reward/risk after execution costs is below minimum")
            return false
        end
    end

    local valuemap = core.valuemap()
    valuemap.Command = "CreateOrder"
    valuemap.OrderType = "OM"
    valuemap.OfferID = Rt.Offer
    valuemap.AcctID = Rt.Account
    valuemap.Quantity = units
    valuemap.BuySell = side
    valuemap.CustomID = Cfg.CustomID

    -- Every entry attaches a protective stop. SetStop behavior follows
    -- FixedStopVolatilityPolicy; safety floors are always mandatory.
    valuemap.PegTypeStop = "O"
    if side == "B" then valuemap.PegPriceOffsetPipsStop = -stopPips
    else valuemap.PegPriceOffsetPipsStop = stopPips end
    -- The real stop is tightened explicitly with EditOrder. No separate native
    -- trailing algorithm competes with the strategy's ATR ratchet.

    -- Record the exact distance placed on the broker's stop (adaptive OR the
    -- SetStop fixed-pip override, whichever was actually used above) so the
    -- thesis-stop/trailing logic can bind it to this trade's real risk once
    -- its TradeID appears in manageOpenPositions(), instead of recomputing an
    -- "initial risk" from whatever the regime/ATR happen to be on a later bar.
    -- Likewise, Set Limit Orders overrides the adaptive target with the fixed
    -- APS-style Limit value. With the switch OFF, the adaptive target is used.
    valuemap.PegTypeLimit = "O"
    if side == "B" then valuemap.PegPriceOffsetPipsLimit = targetPips
    else valuemap.PegPriceOffsetPipsLimit = -targetPips end

    if not Rt.CanClose then valuemap.EntryLimitStop = "Y" end

    local cookie = allocateAsyncCookie()
    local success, msg = terminal:execute(cookie, valuemap)
    if not success then
        local failedText = string.format("%s | OPEN_FAILED side=%s broker=%s",
            STRATEGY_NAME, side == "B" and "BUY" or "SELL", tostring(msg))
        writeCSVLog("OPEN_FAILED", failedText, closedBarEndDate(p) or Rt.Source:date(p))
        alert(failedText)
        return false
    end
    local pending = {risk=stopPips * pip, target=targetPips * pip, side=side, period=p,
        submittedAt=closedBarEndDate(p) or Rt.Source:date(p),
        regime=orderRegime, baseRegime=Rt.currentBaseRegime,
        setupKey=setupKey, setupAnchor=setupAnchor,
        globalSetupKey=Rt.globalSetupFingerprint(side, orderRegime, entryType, setupAnchor),
        mlFeatures=mlDecision ~= nil and mlDecision.features or nil,
        mlProbability=mlDecision ~= nil and mlDecision.probability or nil,
        score=entryScore, required=entryRequired, entryType=entryType,
        entryEngine=entryEngine or Cfg.EntryEngineMode or "UNKNOWN",
        signalPrice=Context.close, signalATR=Context.atr, signalVWAP=Context.vwap,
        signalEMAfast=Context.emaFast, signalEMAmed=Context.emaMed, signalEMAslow=Context.emaSlow,
        signalPriceToFastEMAATR=safeDiv((side == "B" and 1 or -1)
            * (Context.close - Context.emaFast), Context.atr, 0),
        signalPriceToMedEMAATR=safeDiv((side == "B" and 1 or -1)
            * (Context.close - Context.emaMed), Context.atr, 0),
        signalPriceToSlowEMAATR=safeDiv((side == "B" and 1 or -1)
            * (Context.close - Context.emaSlow), Context.atr, 0),
        signalFastMedGapATR=safeDiv((side == "B" and 1 or -1)
            * (Context.emaFast - Context.emaMed), Context.atr, 0),
        signalMedSlowGapATR=safeDiv((side == "B" and 1 or -1)
            * (Context.emaMed - Context.emaSlow), Context.atr, 0),
        signalFastSlopeATR=safeDiv((side == "B" and 1 or -1)
            * Context.emaFastSlope, Context.atr, 0),
        signalMedSlopeATR=safeDiv((side == "B" and 1 or -1)
            * (tonumber(Context.emaMedSlope) or 0), Context.atr, 0),
        signalTriggerBodyATR=safeDiv((side == "B" and 1 or -1)
            * (Context.close - Context.open), Context.atr, 0),
        signalTriggerCloseLocation=side == "B"
            and safeDiv(Context.close - Context.low, max(Context.high - Context.low, 1e-9), 0.5)
            or safeDiv(Context.high - Context.close, max(Context.high - Context.low, 1e-9), 0.5),
        signalVWAPDistATR=Context.vwapDistATR,
        signalFastGapATR=safeDiv(abs(Context.close - Context.emaFast), Context.atr, 0),
        signalRSI=Context.rsi, signalMomentumATR=Context.momentumATR,
        signalADX=Context.adx, signalDIPlus=Context.plusDirection,
        signalDIMinus=Context.minusDirection, signalSpreadPips=spreadPips(p),
        signalSession=Rt.activeMarketSession, signalHTFTrend=Rt.htfTrend,
        signalRegimeBest=Rt.regimeBestScore, signalRegimeSecond=Rt.regimeSecondScore,
        signalRegimeMargin=Rt.regimeEffectiveMargin,
        scoreTrendUp=Scores.trendUp, scoreTrendDown=Scores.trendDown,
        scoreTrendUpBase=Scores.trendUpBase, scoreTrendDownBase=Scores.trendDownBase,
        scoreRange=Scores.range, scoreBreakout=Scores.breakout,
        scoreReversalBull=Scores.reversalBull, scoreReversalBear=Scores.reversalBear,
        scoreHighVol=Scores.highVol, scoreLowVol=Scores.lowVol,
        signalStructureBias=Context.marketStructureBias,
        signalStructureSequence=Context.marketStructureSequence,
        signalStructureHighLabel=Context.marketStructureLastHigh ~= nil
            and Context.marketStructureLastHigh.label or nil,
        signalStructureHighValue=Context.marketStructureLastHigh ~= nil
            and Context.marketStructureLastHigh.value or nil,
        signalStructureLowLabel=Context.marketStructureLastLow ~= nil
            and Context.marketStructureLastLow.label or nil,
        signalStructureLowValue=Context.marketStructureLastLow ~= nil
            and Context.marketStructureLastLow.value or nil,
        signalStructureBOSUp=yn(Context.marketStructureBOSUp),
        signalStructureBOSDown=yn(Context.marketStructureBOSDown),
        signalStructureCHOCH=yn(Context.marketStructureCHOCH),
        signalStructureCHOCHDirection=Context.marketStructureCHOCHDirection,
        signalStructureHighAge=Context.marketStructureHighAge,
        signalStructureLowAge=Context.marketStructureLowAge,
        signalStructureStale=yn(Context.marketStructureStale),
        signalStructureWeightSide=Rt.marketStructure.appliedSide,
        signalStructureWeight=Rt.marketStructure.appliedWeight,
        signalATRBreakHigh=yn(Context.breakHigh),
        signalATRBreakLow=yn(Context.breakLow)}
    local requestId = parseOrderRequestId(msg)
    if requestId ~= nil then
        Rt.pendingOpenRequests[requestId] = pending
    else
        -- Keep exactly one guarded fallback and block further entries until the
        -- trade appears or the asynchronous result reports failure.
        Rt.pendingUnknownOpen = pending
        debug("OPEN ACCEPTED without parseable request ID: " .. tostring(msg))
    end
    Rt.pendingOpenCookies[cookie] = {requestId=requestId, pending=pending}
    return true, stopPips, targetPips, units, requestId, cookie
end

local function hasUnrelatedSideTrades(side)
    local enum = core.host:findTable("trades"):enumerator()
    local row = enum:next()
    while row ~= nil do
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer and row.BS == side and row.QTXT ~= Cfg.CustomID then
            return true
        end
        row = enum:next()
    end
    return false
end

local function closeTrade(tradeRow, reason)
    if not Cfg.AllowTrade then return true end
    if not Rt.CanClose then
        -- A FIFO/netting close is account/instrument/direction-wide. CustomID
        -- does not scope what the broker closes, so refuse the command while
        -- an unrelated same-side position exists.
        if hasUnrelatedSideTrades(tradeRow.BS) then
            local tradeId = tradeRow.TradeID
            local blocked = Rt.blockedExits[tradeId]
            local sinceBar = (blocked and blocked.sinceBar) or (Context and Context.p) or nil
            Rt.blockedExits[tradeId] = {reason = reason, sinceBar = sinceBar, side = tradeRow.BS}
            -- Only alert on the FIRST bar this trade's exit becomes blocked;
            -- traceFullBar()'s per-bar diagnostic line carries the ongoing
            -- state afterward so this can't silently repeat unnoticed but
            -- also doesn't spam an alert every closed bar.
            if blocked == nil then
                alert("EXIT BLOCKED: FIFO net close for " .. tostring(reason) .. " would affect unrelated "
                    .. tostring(tradeRow.BS) .. " positions - protection now relies solely on the static broker stop")
            end
            return false
        end
        Rt.blockedExits[tradeRow.TradeID] = nil
        if Rt.fifoClosePending[tradeRow.BS] then return true end
    else
        -- Per-trade close: don't resubmit a redundant CM close for a TradeID
        -- whose close is still awaiting confirmation (the trade can remain
        -- visible in "trades" for more than one closed bar while the async
        -- close is in flight).
        if Rt.closePendingTradeIds[tradeRow.TradeID] then return true end
    end
    local valuemap = core.valuemap()
    valuemap.Command = "CreateOrder"
    valuemap.OrderType = "CM"
    valuemap.OfferID = Rt.Offer
    valuemap.AcctID = Rt.Account
    if Rt.CanClose then
        valuemap.TradeID = tradeRow.TradeID
        valuemap.Quantity = tradeRow.Lot
    else
        valuemap.NetQtyFlag = "Y"
    end
    valuemap.BuySell = tradeRow.BS == "B" and "S" or "B"
    valuemap.CustomID = Cfg.CustomID
    local cookie = allocateAsyncCookie()
    local success, msg = terminal:execute(cookie, valuemap)
    if success then
        local pending = {period=Rt.processingPeriod or (Context and Context.p) or nil, cookie=cookie}
        if not Rt.CanClose then
            Rt.fifoClosePending[tradeRow.BS] = pending
            Rt.pendingCloseCookies[cookie] = {fifoSide=tradeRow.BS, period=pending.period,
                pending=pending}
        else
            Rt.closePendingTradeIds[tradeRow.TradeID] = pending
            Rt.pendingCloseCookies[cookie] = {tradeId=tradeRow.TradeID, period=pending.period,
                pending=pending}
        end
        Rt.tradeExitReasons[tradeRow.TradeID] = tostring(reason)
        Rt.tradeExitReasons[tostring(tradeRow.TradeID)] = tostring(reason)
        alert("EXIT_SUBMITTED reason=" .. tostring(reason))
    else
        alert("EXIT_SUBMIT_FAILED reason=" .. tostring(reason) .. " broker=" .. tostring(msg))
    end
    return success
end

local function closeOwnSide(side, reason)
    local enum = core.host:findTable("trades"):enumerator()
    local row = enum:next()
    while row ~= nil do
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer and row.QTXT == Cfg.CustomID and (side == nil or row.BS == side) then
            closeTrade(row, reason)
        end
        row = enum:next()
    end
end

local function processMandatoryClose(p)
    if not Cfg.UseMandatoryClose then return false end

    local barDate = closedBarEndDate(p) or Rt.Source:date(p)
    local _, clock = getSessionTime(barDate)
    local dayKey = getDayKey(barDate)
    local crossedAtMidnight = Rt.lastMandatorySessionKey ~= nil
        and Rt.lastMandatorySessionKey ~= dayKey
        and Rt.lastMandatorySessionClock ~= nil
        and Rt.lastMandatorySessionClock < Rt.MandatoryCloseTime

    -- Carry a missed 23:59 trigger into the new day when the timeframe moves
    -- directly from (for example) 23:55 to 00:00. Keep retrying until this
    -- strategy has no open trades, including after an asynchronous rejection.
    if crossedAtMidnight then Rt.mandatoryCloseCarryoverDay = dayKey end
    local inCloseWindow = clock >= Rt.MandatoryCloseTime
    local carryover = Rt.mandatoryCloseCarryoverDay == dayKey

    -- Restart recovery: if the terminal was offline across the configured
    -- close, the in-memory midnight-crossing state is gone. Any strategy-owned
    -- trade opened on an earlier session day is therefore overdue and must be
    -- liquidated before new entries are permitted.
    if Cfg.AllowTrade and checkReady("trades") and not inCloseWindow then
        local trades = core.host:findTable("trades")
        if trades ~= nil then
            local enum = trades:enumerator()
            local row = enum:next()
            while row ~= nil do
                local openTime = row.Time or row.OpenTime -- OpenTime is compatibility-only
                if row.AccountID == Rt.Account and row.OfferID == Rt.Offer
                    and row.QTXT == Cfg.CustomID and openTime ~= nil
                    and getDayKey(openTime) ~= dayKey then
                    Rt.mandatoryCloseCarryoverDay = dayKey
                    carryover = true
                    break
                end
                row = enum:next()
            end
        end
    end

    Rt.lastMandatorySessionKey = dayKey
    Rt.lastMandatorySessionClock = clock

    if inCloseWindow or carryover then
        if Cfg.AllowTrade and checkReady("trades") then
            local openCount = ownTradesCount(nil)
            if openCount > 0 then
                closeOwnSide(nil, "mandatory close " .. tostring(instance.parameters.MandatoryCloseTime))
            elseif carryover then
                Rt.mandatoryCloseCarryoverDay = nil
                carryover = false
            end
        end
        -- The normal same-day close window remains blocked through midnight.
        -- A midnight carryover blocks only until liquidation is confirmed.
        return inCloseWindow or carryover
    end
    return false
end

-- =========================
-- Open-position management
-- =========================
local function tradeOpenTime(tradeRow)
    -- The documented open Trades table field is Time. OpenTime is retained
    -- only as a compatibility fallback for nonstandard/debugger table rows.
    return tradeRow.Time or tradeRow.OpenTime
end

local function tradeOpenBarIndex(tradeRow, currentP)
    -- Map trade open time into Rt.Source. This mirrors uploaded strategies' findDate usage.
    local openTime = tradeOpenTime(tradeRow)
    if openTime == nil then return nil end
    local idx = core.findDate(Rt.Source, openTime, false)
    if idx == -1 then return nil end
    return idx
end

local function barsElapsedInTrade(tradeRow, p)
    -- Exact path: resolve the trade's open time to a real bar index.
    local idx = tradeOpenBarIndex(tradeRow, p)
    -- Count completed held candles inclusively: when the first bar containing
    -- the open has closed, bars_held=1. This makes MaxBarsInTrade=N fire on
    -- the Nth completed held candle instead of one candle later.
    if idx ~= nil then return max(0, p - idx + 1) end

    -- Fallback path: findDate failed (data gap, or the position predates the
    -- subscribed history window after a restart). Without this, MaxBarsInTrade
    -- silently stops applying to this trade for its entire remaining life,
    -- every single bar, with no signal that protection quietly degraded.
    -- Use the number of actually loaded market bars as a safe lower bound.
    -- Calendar minutes can overcount hundreds of nonexistent bars across a
    -- weekend and force a premature exit immediately after the market reopens.
    local tradeId = tradeRow.TradeID
    local openTime = tradeOpenTime(tradeRow)
    if openTime == nil then
        if not Rt.barIndexFallbackWarned[tradeId] then
            Rt.barIndexFallbackWarned[tradeId] = true
            alert("MAX-BARS PROTECTION DEGRADED: Trades.Time unavailable for TradeID=" .. tostring(tradeId))
        end
        return nil
    end
    if not Rt.barIndexFallbackWarned[tradeId] then
        Rt.barIndexFallbackWarned[tradeId] = true
        alert("MAX-BARS PROTECTION: using loaded-bar lower bound for TradeID=" .. tostring(tradeId)
            .. " (open time predates subscribed history)")
    end
    return max(0, p - Rt.Source:first() + 1)
end

local function bindTradeInitialRisk(tradeRow)
    -- Claim the stop distance that was actually sent to the broker for the
    -- matching OpenOrderReqID the first time this TradeID is seen. For a
    -- recovered trade, use only broker evidence; never invent
    -- old risk from the current bar's ATR/regime.
    local tradeId = tradeRow.TradeID
    if Rt.tradeInitialRisk[tradeId] ~= nil then return Rt.tradeInitialRisk[tradeId] end
    if Rt.tradeRiskUnavailable[tradeId] then return nil end
    -- Persisted entry-time risk always wins over a broker stop that may already
    -- have ratcheted to break-even or profit before this strategy restarted.
    loadTradeMetadata(tradeId)
    if Rt.tradeInitialRisk[tradeId] ~= nil then
        Rt.tradeRecovered[tradeId] = true
        tradeAnalyticsSnapshot(tradeRow, nil, Rt.tradeInitialRisk[tradeId])
        return Rt.tradeInitialRisk[tradeId]
    end
    local requestId = tradeRow.OpenOrderReqID ~= nil and tostring(tradeRow.OpenOrderReqID) or nil
    local pending = requestId ~= nil and Rt.pendingOpenRequests[requestId] or nil
    if pending ~= nil and pending.side == tradeRow.BS then
        Rt.pendingOpenRequests[requestId] = nil
    elseif Rt.pendingUnknownOpen ~= nil and Rt.pendingUnknownOpen.side == tradeRow.BS then
        pending = Rt.pendingUnknownOpen
        Rt.pendingUnknownOpen = nil
    else
        pending = nil
    end
    if pending ~= nil then forgetOpenCookiesForPending(pending) end
    local risk = pending ~= nil and pending.risk or nil
    Rt.tradeRecovered[tradeId] = pending == nil
    if risk == nil or risk <= 0 then
        local brokerStop = tonumber(tradeRow.Stop)
        local openRate = tonumber(tradeRow.Open)
        if validNumber(brokerStop) and brokerStop > 0 and validNumber(openRate) then
            -- A stop at entry or already through entry is a ratcheted management
            -- stop, not evidence of the original risk. Fail safe instead of
            -- converting it into zero/tiny R and corrupting all later exits.
            local stillOnRiskSide = (tradeRow.BS == "B" and brokerStop < openRate)
                or (tradeRow.BS == "S" and brokerStop > openRate)
            if stillOnRiskSide then risk = abs(openRate - brokerStop) end
        end
    end
    if risk ~= nil and risk > 0 then
        Rt.tradeInitialRisk[tradeId] = risk
    else
        Rt.tradeRiskUnavailable[tradeId] = true
    end
    if pending ~= nil then
        Rt.tradeEntryRegime[tradeId] = pending.regime
        Rt.tradeEntryEngine[tradeId] = pending.entryEngine or "UNKNOWN"
        Rt.tradeSetupAnchor[tradeId] = pending.setupAnchor
        if pending.mlFeatures ~= nil then
            Rt.tradeMLFeatures[tradeId] = pending.mlFeatures
            Rt.tradeMLFeatures[tostring(tradeId)] = pending.mlFeatures
        end
        persistTradeMetadata(tradeId)
    else
        -- Entry regime/anchor may still be available even when legacy builds
        -- did not persist initial risk.
        loadTradeMetadata(tradeId)
    end
    if risk ~= nil and risk > 0 then persistTradeMetadata(tradeId) end
    tradeAnalyticsSnapshot(tradeRow, pending, risk)
    if pending == nil and (risk == nil or Rt.tradeEntryRegime[tradeId] == nil)
        and not Rt.tradeRecoveryWarned[tradeId] then
        Rt.tradeRecoveryWarned[tradeId] = true
        local riskText = risk ~= nil and string.format("%.1fp", risk / sourcePipSize()) or "UNAVAILABLE"
        local managementText = risk == nil
            and "; synthetic R-based trailing unavailable; existing broker stop remains authoritative"
            or "; entry-regime/anchor metadata unavailable, using generic exits"
        alert("RECOVERED TRADE: TradeID=" .. tostring(tradeId)
            .. " initialRisk=" .. riskText
            .. managementText)
    end
    return risk
end

local function executableExitPrice(side, p)
    -- Closing a long sells at BID; closing a short buys at ASK. Read the
    -- synchronized CLOSED bar, never NOW, so live and backtest behavior agree.
    local bid, ask = closedBidAsk(p)
    local price = side == "B" and bid or ask
    return validNumber(price) and price or nil
end

local function thesisCandidate(side, openRate, initialRisk, managementPrice, atr)
    if not (validNumber(openRate) and validNumber(initialRisk) and initialRisk > 0
        and validNumber(managementPrice) and validNumber(atr) and atr > 0) then return nil end
    local profit = side == "B" and (managementPrice - openRate) or (openRate - managementPrice)
    local profitR = profit / initialRisk
    local costOffset = Rt.breakEvenCostOffset()
    local trailDist = Cfg.TrailATR * atr
    if Cfg.UseSmartTradeManagement and profitR >= (Cfg.TrailTightenAfterR or 2.0) then
        trailDist = trailDist * (Cfg.TrailTightenFactor or 0.65)
    end
    -- Never trail tighter than MinTrailPips (stops noise from ratcheting into the spread).
    local minTrail = (tonumber(Cfg.MinTrailPips) or 0) * sourcePipSize()
    if minTrail > 0 then trailDist = max(trailDist, minTrail) end
    if side == "B" then
        local candidate = openRate - initialRisk
        if profit >= Cfg.BreakEvenR * initialRisk and profit > costOffset then
            candidate = max(candidate, openRate + costOffset)
            candidate = max(candidate, managementPrice - trailDist)
        end
        -- Lock a fraction of R once LockProfitR is reached (monotonic with ratchet).
        if Cfg.UseSmartTradeManagement and profitR >= (Cfg.LockProfitR or 1.5) then
            local locked = openRate + (Cfg.LockProfitFraction or 0.5) * initialRisk
            candidate = max(candidate, locked)
        end
        return candidate
    end
    local candidate = openRate + initialRisk
    if profit >= Cfg.BreakEvenR * initialRisk and profit > costOffset then
        candidate = min(candidate, openRate - costOffset)
        candidate = min(candidate, managementPrice + trailDist)
    end
    if Cfg.UseSmartTradeManagement and profitR >= (Cfg.LockProfitR or 1.5) then
        local locked = openRate - (Cfg.LockProfitFraction or 0.5) * initialRisk
        candidate = min(candidate, locked)
    end
    return candidate
end

local function rebuildHistoricalTrail(tradeRow, p, initialRisk)
    local openRate = tonumber(tradeRow.Open)
    if not validNumber(openRate) or not validNumber(initialRisk) then return nil end
    local stop = tradeRow.BS == "B" and (openRate - initialRisk) or (openRate + initialRisk)
    local first = tradeOpenBarIndex(tradeRow, p)
    -- If the trade predates loaded history, replay every bar we do have. This
    -- cannot recover a high-water mark older than the subscription, but it is
    -- strictly safer than rebuilding from only the current bar.
    if first == nil then first = Rt.Source:first() end
    first = max(first, Rt.Source:first())
    for i = first, p do
        local candidate = thesisCandidate(tradeRow.BS, openRate, initialRisk,
            executableExitPrice(tradeRow.BS, i), Ind.atr[i])
        if candidate ~= nil then
            if tradeRow.BS == "B" then stop = max(stop, candidate)
            else stop = min(stop, candidate) end
        end
    end
    debug("RECOVERED TRAIL REPLAY | TradeID=" .. tostring(tradeRow.TradeID)
        .. " bars=" .. tostring(p - first + 1) .. " stop=" .. tostring(stop))
    return stop
end

local function updateTrailingStop(tradeRow, p)
    -- This is a genuine ratchet: the stop is persisted per TradeID in
    -- Rt.trailStops and only ever tightened (max for longs / min for shorts)
    -- against the level already reached, matching the pattern used by the
    -- v11.0 reference strategy's trailStop/math.max mechanism. A stop that
    -- gets recomputed from scratch every bar (the old behavior) can loosen
    -- after a pullback and silently give back the break-even/ATR protection
    -- already earned; ratcheting against the stored value prevents that.
    local openRate = tonumber(tradeRow.Open)
    if not validNumber(openRate) then return nil end
    local tradeId = tradeRow.TradeID
    local initialRisk = bindTradeInitialRisk(tradeRow)
    if initialRisk == nil or initialRisk <= 0 then return nil end
    local managementPrice = executableExitPrice(tradeRow.BS, p)
    if managementPrice == nil then return Rt.trailStops[tradeId] end
    local storedStop = Rt.trailStops[tradeId]
    local priorStop = storedStop
    if priorStop == nil and Rt.tradeRecovered[tradeId] then
        priorStop = rebuildHistoricalTrail(tradeRow, p, initialRisk)
    end
    if priorStop == nil then
        priorStop = tradeRow.BS == "B" and (openRate - initialRisk) or (openRate + initialRisk)
    end
    local candidate = thesisCandidate(tradeRow.BS, openRate, initialRisk, managementPrice, Ind.atr[p])
    if candidate == nil then return priorStop end

    -- Apply the tightest earned candidate now; an artificial entry-only
    -- intermediate stop would discard this bar's valid profit lock/trail.
    local thesisStop
    if tradeRow.BS == "B" then
        thesisStop = max(priorStop or candidate, candidate)
    else
        thesisStop = min(priorStop or candidate, candidate)
    end
    Rt.trailStops[tradeId] = thesisStop
    if storedStop ~= thesisStop then persistTradeMetadata(tradeId) end
    return thesisStop
end

local function normalizedStopRate(side, rate)
    if not validNumber(rate) then return nil end
    local precision = Rt.Source:getPrecision()
    local factor = 10 ^ precision
    if side == "B" then
        return math.floor(rate * factor + 1e-7) / factor
    end
    return math.ceil(rate * factor - 1e-7) / factor
end

local function stopOrderUsable(orderRow, tradeRow)
    if orderRow == nil then return false end
    if orderRow.AccountID ~= Rt.Account or orderRow.OfferID ~= Rt.Offer then return false end
    if tostring(orderRow.Type or "") ~= "S" or tostring(orderRow.FixStatus or "") ~= "W" then return false end
    local expectedSide = tradeRow.BS == "B" and "S" or "B"
    return orderRow.BS == expectedSide
end

local function findLiveStopOrder(tradeRow)
    if not checkReady("orders") then return nil, "orders table not ready" end
    local orders = core.host:findTable("orders")
    if orders == nil then return nil, "orders table unavailable" end

    local directId = nonEmptyString(tradeRow.StopOrderID)
    if directId ~= nil then
        local direct = orders:find("OrderID", directId)
        local linkedTradeId = direct ~= nil and nonEmptyString(direct.TradeID) or nil
        if stopOrderUsable(direct, tradeRow)
            and (linkedTradeId == nil or linkedTradeId == tostring(tradeRow.TradeID)) then return direct, nil end
    end

    -- FIFO/ELS trades do not expose StopOrderID. Resolve the strategy-owned
    -- waiting stop by account, instrument, CustomID and closing side. Prefer
    -- an exact TradeID link where the host provides one; accept a fallback
    -- only for an unlinked order. An explicit foreign TradeID can never be
    -- borrowed, even if it is the sole waiting stop in the strategy scope.
    local exact, exactCount = nil, 0
    local scoped, scopedCount = nil, 0
    local tradeId = tostring(tradeRow.TradeID)
    local enum = orders:enumerator()
    local row = enum:next()
    while row ~= nil do
        if stopOrderUsable(row, tradeRow) and row.QTXT == Cfg.CustomID then
            local linkedTradeId = nonEmptyString(row.TradeID)
            if linkedTradeId ~= nil and linkedTradeId == tradeId then
                exact, exactCount = row, exactCount + 1
            elseif linkedTradeId == nil then
                scoped, scopedCount = row, scopedCount + 1
            end
        end
        row = enum:next()
    end
    if exactCount == 1 then return exact, nil end
    if exactCount > 1 then return nil, "multiple waiting stops match TradeID" end
    if scopedCount == 1 then
        if Rt.CanClose ~= false then
            -- Hedged positions need an unambiguous owner as well as a unique
            -- unlinked stop. FIFO/ELS uses one scoped net stop per side.
            if not checkReady("trades") then return nil, "trades table not ready for unlinked stop" end
            local trades = core.host:findTable("trades")
            if trades == nil then return nil, "trades table unavailable for unlinked stop" end
            local count, ownsTarget = 0, false
            local tradeEnum = trades:enumerator()
            local own = tradeEnum:next()
            while own ~= nil do
                if own.AccountID == Rt.Account and own.OfferID == Rt.Offer
                    and own.QTXT == Cfg.CustomID and own.BS == tradeRow.BS then
                    count = count + 1
                    if tostring(own.TradeID) == tradeId then ownsTarget = true end
                end
                own = tradeEnum:next()
            end
            if count ~= 1 or not ownsTarget then return nil, "unlinked stop has ambiguous trade ownership" end
        end
        return scoped, nil
    end
    if scopedCount == 0 then return nil, "no strategy-owned waiting stop found" end
    return nil, "multiple strategy-owned waiting stops are ambiguous"
end

function Rt.liveStopRate(tradeRow)
    local stop = findLiveStopOrder(tradeRow)
    local rate = stop ~= nil and tonumber(stop.Rate) or nil
    return validNumber(rate) and rate > 0 and rate or nil
end

local function updateBrokerStop(tradeRow, desiredRate, p)
    if not Cfg.TrailingStop or not validNumber(desiredRate) then return false end
    local tradeId = tradeRow.TradeID
    if Rt.pendingStopEdits[tradeId] ~= nil then return false end

    local stopOrder, problem = findLiveStopOrder(tradeRow)
    if stopOrder == nil then
        if Rt.stopOrderWarnings[tradeId] ~= problem then
            Rt.stopOrderWarnings[tradeId] = problem
            alert("BROKER STOP EDIT BLOCKED: TradeID=" .. tostring(tradeId) .. " | " .. tostring(problem))
        end
        return false
    end
    local currentRate = tonumber(stopOrder.Rate)
    if not validNumber(currentRate) or currentRate <= 0 then return false end
    -- Use the order table's actual rate, including manual/external tightening.
    Rt.brokerStopRates[tradeId] = currentRate
    local requestedRate = normalizedStopRate(tradeRow.BS, desiredRate)
    if not validNumber(currentRate) or not validNumber(requestedRate) then return false end

    local point = 10 ^ (-Rt.Source:getPrecision())
    local tighter = tradeRow.BS == "B" and requestedRate > currentRate + point * 0.5
        or tradeRow.BS == "S" and requestedRate < currentRate - point * 0.5
    if not tighter then return false end

    -- Do not send an already marketable/invalid stop edit after a gap. The
    -- closed-bar market-close fallback below remains responsible for exiting.
    local liveBid, liveAsk = tonumber(instance.bid[NOW]), tonumber(instance.ask[NOW])
    if tradeRow.BS == "B" and (not validNumber(liveBid) or requestedRate >= liveBid) then return false end
    if tradeRow.BS == "S" and (not validNumber(liveAsk) or requestedRate <= liveAsk) then return false end

    Rt.stopOrderWarnings[tradeId] = nil

    local valuemap = core.valuemap()
    valuemap.Command = "EditOrder"
    valuemap.OrderID = stopOrder.OrderID
    valuemap.AcctID = Rt.Account
    valuemap.Rate = requestedRate
    valuemap.TrailUpdatePips = 0
    local cookie = allocateAsyncCookie()
    local success, msg = terminal:execute(cookie, valuemap)
    if not success then
        alert("BROKER STOP EDIT FAILED: TradeID=" .. tostring(tradeId) .. " | " .. tostring(msg))
        return false
    end

    local pending = {cookie=cookie, tradeId=tradeId, orderId=stopOrder.OrderID,
        requestedRate=requestedRate, previousRate=currentRate, period=p}
    Rt.pendingStopEdits[tradeId] = pending
    Rt.pendingStopEditCookies[cookie] = pending
    debug(string.format("BROKER STOP EDIT SENT | TradeID=%s OrderID=%s %.5f -> %.5f",
        tostring(tradeId), tostring(stopOrder.OrderID), currentRate, requestedRate))
    return true
end

local function pruneStaleTrailState(openTradeIds)
    -- Drop trailing-stop/initial-risk/pending-close entries for TradeIDs no
    -- longer open (closed by us, by the broker's own stop/limit, or
    -- manually), so a future unrelated trade can never inherit a stale stop
    -- level or a stuck pending-close guard, and the tables don't grow
    -- unbounded over a long session.
    local trackedIds = {}
    local function collectTracked(map)
        for id, _ in pairs(map) do trackedIds[id] = true end
    end
    collectTracked(Rt.tradeInitialRisk)
    collectTracked(Rt.tradeEntryRegime)
    collectTracked(Rt.tradeEntryEngine)
    collectTracked(Rt.tradeAnalytics)
    collectTracked(Rt.closePendingTradeIds)
    collectTracked(Rt.tradeExitReasons)
    local function trackedTradeIsOpen(id)
        return openTradeIds[id] == true
            or openTradeIds[tostring(id)] == true
            or (tonumber(id) ~= nil and openTradeIds[tonumber(id)] == true)
    end
    for id, _ in pairs(trackedIds) do
        if not trackedTradeIsOpen(id) then
            local key = tostring(id)
            local alreadyClosed = Rt.knownClosedTrades["TRADE:" .. key] == true
            if not alreadyClosed and Rt.awaitingCloseReconciliation[key] == nil then
                Rt.awaitingCloseReconciliation[key] = {
                    period=Rt.processingPeriod or (Context and Context.p) or nil
                }
                alert("CLOSE RECONCILIATION SAFETY LOCK: TradeID=" .. key
                    .. " disappeared before its final closed-trade row was published")
            end
        end
    end

    for id, _ in pairs(Rt.trailStops) do
        if not openTradeIds[id] then
            Rt.trailStops[id] = nil
            runtimePut(tradeStateKey(id, "trailStop"), "")
        end
    end
    for id, _ in pairs(Rt.tradeInitialRisk) do
        if not trackedTradeIsOpen(id) and Rt.awaitingCloseReconciliation[tostring(id)] == nil then
            Rt.tradeInitialRisk[id] = nil
            runtimePut(tradeStateKey(id, "initialRisk"), "")
        end
    end
    for id, _ in pairs(Rt.tradeEntryRegime) do
        if not openTradeIds[id] then
            Rt.tradeEntryRegime[id] = nil
            runtimePut(tradeStateKey(id, "regime"), "")
        end
    end
    for id, _ in pairs(Rt.tradeEntryEngine) do
        if not openTradeIds[id] then
            Rt.tradeEntryEngine[id] = nil
            runtimePut(tradeStateKey(id, "engine"), "")
        end
    end
    for id, _ in pairs(Rt.tradeSetupAnchor) do
        if not openTradeIds[id] then
            Rt.tradeSetupAnchor[id] = nil
            runtimePut(tradeStateKey(id, "anchor"), "")
        end
    end
    for id, _ in pairs(Rt.tradeRiskUnavailable) do
        if not openTradeIds[id] then Rt.tradeRiskUnavailable[id] = nil end
    end
    for id, _ in pairs(Rt.tradeRecovered) do
        if not openTradeIds[id] then Rt.tradeRecovered[id] = nil end
    end
    for id, _ in pairs(Rt.tradeRecoveryWarned) do
        if not openTradeIds[id] then Rt.tradeRecoveryWarned[id] = nil end
    end
    for id, _ in pairs(Rt.closePendingTradeIds) do
        if not openTradeIds[id] and Rt.awaitingCloseReconciliation[tostring(id)] == nil then
            Rt.closePendingTradeIds[id] = nil
        end
    end
    for id, _ in pairs(Rt.blockedExits) do
        if not openTradeIds[id] then Rt.blockedExits[id] = nil end
    end
    for id, _ in pairs(Rt.barIndexFallbackWarned) do
        if not openTradeIds[id] then Rt.barIndexFallbackWarned[id] = nil end
    end
    for id, _ in pairs(Rt.brokerStopRates) do
        if not openTradeIds[id] then Rt.brokerStopRates[id] = nil end
    end
    for id, _ in pairs(Rt.stopOrderWarnings) do
        if not openTradeIds[id] then Rt.stopOrderWarnings[id] = nil end
    end
    for id, pending in pairs(Rt.pendingStopEdits) do
        if not openTradeIds[id] then
            if pending.cookie ~= nil then Rt.pendingStopEditCookies[pending.cookie] = nil end
            Rt.pendingStopEdits[id] = nil
        end
    end
    for cookie, tracked in pairs(Rt.pendingCloseCookies) do
        if tracked.tradeId ~= nil and not openTradeIds[tracked.tradeId]
            and Rt.awaitingCloseReconciliation[tostring(tracked.tradeId)] == nil then
            Rt.pendingCloseCookies[cookie] = nil
        end
    end
end

local function inheritPartialTradeState(tradeRow)
    local tradeId = tradeRow.TradeID
    local origin = nonEmptyString(tradeRow.TradeIDOrigin)
    if tradeId == nil or origin == nil or tostring(tradeId) == origin then return end
    -- Recover lineage before binding a restarted remaining position. Each
    -- child persists the root so A -> B -> C still updates A after restart.
    if Rt.tradeInitialRisk[origin] == nil and Rt.tradeExitFeatures[origin] == nil then loadTradeMetadata(origin) end
    if Rt.tradeInitialRisk[tradeId] == nil and Rt.tradeExitFeatures[tradeId] == nil then loadTradeMetadata(tradeId) end
    local root = Rt.tradeLineageRoot[origin] or Rt.tradeLineageRoot[tradeId] or origin
    local metadataInherited = Rt.tradeLineageRoot[tradeId] ~= root
    Rt.tradeLineageRoot[tradeId] = root
    local maps = {
        Rt.trailStops, Rt.tradeInitialRisk, Rt.tradeEntryRegime, Rt.tradeEntryEngine,
        Rt.tradeSetupAnchor, Rt.tradeRiskUnavailable, Rt.tradeRecovered,
        Rt.tradeRecoveryWarned, Rt.barIndexFallbackWarned, Rt.blockedExits,
        Rt.brokerStopRates, Rt.stopOrderWarnings, Rt.tradeMLFeatures, Rt.tradeExitFeatures,
        Rt.tradeAnalytics, Rt.tradeExitReasons
    }
    for i = 1, #maps do
        if maps[i][tradeId] == nil and maps[i][origin] ~= nil then
            maps[i][tradeId] = maps[i][origin]
            if maps[i] == Rt.tradeEntryRegime or maps[i] == Rt.tradeEntryEngine or maps[i] == Rt.tradeSetupAnchor
                or maps[i] == Rt.tradeInitialRisk or maps[i] == Rt.trailStops
                or maps[i] == Rt.tradeMLFeatures or maps[i] == Rt.tradeExitFeatures then
                metadataInherited = true
            end
        end
    end
    if metadataInherited then persistTradeMetadata(tradeId) end
end

local function executableBarExtremes(side, p)
    local source = side == "B" and Rt.BidSource or Rt.AskSource
    if source == nil or Rt.Source == nil then return nil, nil end
    local idx = p
    if source ~= Rt.Source then
        idx = core.findDate(source, Rt.Source:date(p), true)
        if idx == -1 or not validNumber(source:date(idx))
            or abs(source:date(idx) - Rt.Source:date(p)) > 1e-9 then return nil, nil end
    end
    return tonumber(source.high[idx]), tonumber(source.low[idx])
end

function Rt.updateTradeExcursions(tradeRow, p)
    local tradeId = tradeRow.TradeID
    local snapshot = Rt.tradeAnalytics[tradeId] or Rt.tradeAnalytics[tostring(tradeId)]
    if snapshot == nil then snapshot = tradeAnalyticsSnapshot(tradeRow, nil, Rt.tradeInitialRisk[tradeId]) end
    if snapshot == nil or not validNumber(snapshot.entryPrice) then return nil end
    local entryTime = tonumber(snapshot.entryTime or tradeOpenTime(tradeRow))
    local barStart, barEnd = Rt.Source:date(p), closedBarEndDate(p)
    if validNumber(entryTime) and validNumber(barEnd) and entryTime >= barEnd - 1e-9 then
        return snapshot, nil, nil, nil -- closed candle predates this trade
    end
    local currentPrice = executableExitPrice(tradeRow.BS, p)
    local barHigh, barLow
    if validNumber(entryTime) and validNumber(barStart) and entryTime <= barStart + 1e-9 then
        barHigh, barLow = executableBarExtremes(tradeRow.BS, p)
    end
    -- An intrabar/unknown entry cannot claim the whole candle's excursion.
    if not validNumber(barHigh) then barHigh = currentPrice end
    if not validNumber(barLow) then barLow = currentPrice end
    if validNumber(barHigh) and validNumber(barLow) then
        local sign = tradeRow.BS == "B" and 1 or -1
        local favorable = sign * ((tradeRow.BS == "B" and barHigh or barLow) - snapshot.entryPrice)
        local adverse = -sign * ((tradeRow.BS == "B" and barLow or barHigh) - snapshot.entryPrice)
        snapshot.mfePrice = max(snapshot.mfePrice or 0, max(0, favorable))
        snapshot.maePrice = max(snapshot.maePrice or 0, max(0, adverse))
    end
    return snapshot, currentPrice, barHigh, barLow
end

local function professionalTradeUpdate(tradeRow, p, barsElapsed, pendingExitReason)
    local tradeId = tradeRow.TradeID
    local snapshot, currentPrice, barHigh, barLow = Rt.updateTradeExcursions(tradeRow, p)
    if snapshot == nil then return end

    local currentMove = nil
    if validNumber(currentPrice) then
        currentMove = tradeRow.BS == "B" and (currentPrice - snapshot.entryPrice)
            or (snapshot.entryPrice - currentPrice)
    end
    local risk = snapshot.initialRisk
    local currentR = validNumber(currentMove) and validNumber(risk) and risk > 0
        and currentMove / risk or nil
    local stop = Rt.brokerStopRates[tradeId] or tonumber(tradeRow.Stop)
    local thesisStop = Rt.trailStops[tradeId]
    local breakEven = false
    if validNumber(stop) then
        breakEven = tradeRow.BS == "B" and stop >= snapshot.entryPrice
            or tradeRow.BS == "S" and stop <= snapshot.entryPrice
    end
    snapshot.lastBarsHeld = barsElapsed
    snapshot.lastRegime = Rt.currentRegime
    snapshot.lastBaseRegime = Rt.currentBaseRegime
    snapshot.lastBrokerStop = stop
    snapshot.lastThesisStop = thesisStop
    snapshot.lastPrice = currentPrice
    snapshot.lastStructureBias = Context.marketStructureBias
    snapshot.lastStructureSequence = Context.marketStructureSequence
    snapshot.lastStructureCHOCH = Context.marketStructureCHOCH
    snapshot.lastStructureStale = Context.marketStructureStale
    snapshot.lastStructureBOSUp = Context.marketStructureBOSUp
    snapshot.lastStructureBOSDown = Context.marketStructureBOSDown

    if Rt.contextReadyForBar == true and validNumber(Context.atr) and Context.atr > 0
        and validNumber(Context.close) and validNumber(Context.emaFast)
        and validNumber(Context.emaMed) and validNumber(Context.emaSlow) then
        local sideSign = tradeRow.BS == "B" and 1.0 or -1.0
        snapshot.lastManagedATR = Context.atr
        snapshot.lastManagedClose = Context.close
        snapshot.lastManagedEMAfast = Context.emaFast
        snapshot.lastManagedEMAmed = Context.emaMed
        snapshot.lastManagedEMAslow = Context.emaSlow
        snapshot.lastPriceToFastEMAATR = sideSign * (Context.close - Context.emaFast) / Context.atr
        snapshot.lastPriceToMedEMAATR = sideSign * (Context.close - Context.emaMed) / Context.atr
        snapshot.lastPriceToSlowEMAATR = sideSign * (Context.close - Context.emaSlow) / Context.atr
        snapshot.lastFastMedGapATR = sideSign * (Context.emaFast - Context.emaMed) / Context.atr
        snapshot.lastMedSlowGapATR = sideSign * (Context.emaMed - Context.emaSlow) / Context.atr
        snapshot.lastFastSlopeATR = sideSign * (tonumber(Context.emaFastSlope) or 0) / Context.atr
        snapshot.lastMedSlopeATR = sideSign * (tonumber(Context.emaMedSlope) or 0) / Context.atr
        snapshot.lastVWAPDistATR = Context.vwapDistATR
        if Context.emaFast > Context.emaMed and Context.emaMed > Context.emaSlow then
            snapshot.lastEMAStack = "BULLISH"
        elseif Context.emaFast < Context.emaMed and Context.emaMed < Context.emaSlow then
            snapshot.lastEMAStack = "BEARISH"
        else
            snapshot.lastEMAStack = "MIXED"
        end
    end

    local exitFeatures = SmartAI.buildExitFeatures(tradeRow, snapshot, currentR, breakEven, stop)
    if exitFeatures ~= nil then
        snapshot.exitMLFeatures = exitFeatures
        Rt.tradeExitFeatures[tradeId] = exitFeatures
        Rt.tradeExitFeatures[tostring(tradeId)] = exitFeatures
        local root = Rt.tradeLineageRoot[tradeId] or snapshot.tradeId or tradeId
        if tostring(root) ~= tostring(tradeId) then
            Rt.tradeExitFeatures[root] = exitFeatures
            -- Write only exit context: the historical root's entry metadata
            -- need not be loaded in memory after a restart of its child.
            Rt.persistExitTradeFeatures(root)
        end
        local exitProbability, exitSamples = SmartAI.predictExit(exitFeatures)
        snapshot.exitAIProbability = exitProbability
        snapshot.exitAISamples = exitSamples
        snapshot.exitAIStatus = exitSamples >= (Cfg.MLMinSamples or 50) and "OBSERVE" or "WARMUP"
        -- Persist the most recent valid managed state so a restart before the
        -- broker's close confirmation does not discard exit-learning context.
        persistTradeMetadata(tradeId)
    elseif Cfg.MLMode == "OFF" then
        snapshot.exitAIProbability, snapshot.exitAISamples, snapshot.exitAIStatus = nil, 0, "OFF"
    end

    -- MFE/MAE and management snapshots above remain live even with logging off.
    if not Cfg.WriteCSVLogFile or Rt.csvLoggingDisabled then return end
    writeCSVLog("TRADE_UPDATE", analyticsMessage({
        {"trade_id", tradeId, 0}, {"side", tradeRow.BS == "B" and "LONG" or "SHORT"},
        {"bars_held", barsElapsed, 0}, {"entry_price", snapshot.entryPrice, 5},
        {"current_price", currentPrice, 5}, {"unrealized_price", currentMove, 5},
        {"unrealized_r", currentR, 3}, {"bar_high", barHigh, 5}, {"bar_low", barLow, 5},
        {"mfe_price", snapshot.mfePrice, 5}, {"mae_price", snapshot.maePrice, 5},
        {"mfe_pips", snapshot.mfePrice / sourcePipSize(), 2},
        {"mae_pips", snapshot.maePrice / sourcePipSize(), 2},
        {"mfe_r", validNumber(risk) and risk > 0 and snapshot.mfePrice / risk or nil, 3},
        {"mae_r", validNumber(risk) and risk > 0 and snapshot.maePrice / risk or nil, 3},
        {"initial_stop", snapshot.initialStop, 5}, {"broker_stop", stop, 5},
        {"thesis_stop", thesisStop, 5}, {"break_even", breakEven and "Y" or "N"},
        {"managed_close_vs_ema_fast_atr", snapshot.lastPriceToFastEMAATR, 3},
        {"managed_close_vs_ema_medium_atr", snapshot.lastPriceToMedEMAATR, 3},
        {"managed_close_vs_ema_slow_atr", snapshot.lastPriceToSlowEMAATR, 3},
        {"managed_ema_fast_medium_gap_atr", snapshot.lastFastMedGapATR, 3},
        {"managed_ema_medium_slow_gap_atr", snapshot.lastMedSlowGapATR, 3},
        {"managed_ema_fast_slope_atr", snapshot.lastFastSlopeATR, 3},
        {"managed_ema_medium_slope_atr", snapshot.lastMedSlopeATR, 3},
        {"managed_ema_stack", snapshot.lastEMAStack},
        {"managed_vwap_distance_atr", snapshot.lastVWAPDistATR, 3},
        {"exit_ai_probability", snapshot.exitAIProbability, 4},
        {"exit_ai_samples", snapshot.exitAISamples, 0},
        {"exit_ai_status", snapshot.exitAIStatus or "WARMUP"},
        {"exit_ai_mode", "OBSERVE_ONLY"},
        {"entry_regime", snapshot.entryRegime}, {"setup_key", snapshot.setupKey},
        {"quality", snapshot.score, 2}, {"required", snapshot.required, 2},
        {"current_regime", Rt.currentRegime}, {"current_base_regime", Rt.currentBaseRegime},
        {"regime_best", Rt.regimeBestScore, 2}, {"regime_second", Rt.regimeSecondScore, 2},
        {"regime_margin", Rt.regimeEffectiveMargin, 2},
        {"score_trend_up", Scores.trendUp, 2}, {"score_trend_down", Scores.trendDown, 2},
        {"score_trend_up_base", Scores.trendUpBase, 2},
        {"score_trend_down_base", Scores.trendDownBase, 2},
        {"atr", Context.atr, 5}, {"vwap_distance_atr", Context.vwapDistATR, 3},
        {"fast_ma_gap_atr", safeDiv(abs(Context.close - Context.emaFast), Context.atr, 0), 3},
        {"rsi", Context.rsi, 2}, {"momentum_atr", Context.momentumATR, 3},
        {"adx", Context.adx, 2}, {"di_plus", Context.plusDirection, 2},
        {"di_minus", Context.minusDirection, 2}, {"spread_pips", spreadPips(p), 2},
        {"structure_bias", Context.marketStructureBias},
        {"structure_sequence", Context.marketStructureSequence},
        {"structure_last_high_label", Context.marketStructureLastHigh ~= nil and Context.marketStructureLastHigh.label or nil},
        {"structure_last_high", Context.marketStructureLastHigh ~= nil and Context.marketStructureLastHigh.value or nil, 5},
        {"structure_last_low_label", Context.marketStructureLastLow ~= nil and Context.marketStructureLastLow.label or nil},
        {"structure_last_low", Context.marketStructureLastLow ~= nil and Context.marketStructureLastLow.value or nil, 5},
        {"structure_bos_up", yn(Context.marketStructureBOSUp)},
        {"structure_bos_down", yn(Context.marketStructureBOSDown)},
        {"structure_choch", yn(Context.marketStructureCHOCH)},
        {"structure_choch_direction", Context.marketStructureCHOCHDirection},
        {"structure_high_age_bars", Context.marketStructureHighAge, 0},
        {"structure_low_age_bars", Context.marketStructureLowAge, 0},
        {"structure_stale", yn(Context.marketStructureStale)},
        {"structure_weight_side", Rt.marketStructure.appliedSide},
        {"structure_weight", Rt.marketStructure.appliedWeight, 2},
        {"pivot_bos_up", yn(Context.marketStructureBOSUp)},
        {"pivot_bos_down", yn(Context.marketStructureBOSDown)},
        {"atr_break_high", yn(Context.breakHigh)},
        {"atr_break_low", yn(Context.breakLow)},
        {"pending_exit_reason", pendingExitReason}
    }), closedBarEndDate(p) or Rt.Source:date(p))
end

local function manageOpenPositions(p)
    if not Cfg.AllowTrade or not checkReady("trades") then return end
    local enum = core.host:findTable("trades"):enumerator()
    local row = enum:next()
    local openTradeIds = {}
    local openOwnSides = {}
    while row ~= nil do
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer and row.QTXT == Cfg.CustomID then
            inheritPartialTradeState(row)
            openTradeIds[row.TradeID] = true
            Rt.awaitingCloseReconciliation[tostring(row.TradeID)] = nil
            openOwnSides[row.BS] = true
            local exitReason = nil
            local barsElapsed = barsElapsedInTrade(row, p)
            if barsElapsed ~= nil and barsElapsed >= Cfg.MaxBarsInTrade then exitReason = "max bars" end

            -- Bind entry metadata before applying regime-specific management.
            bindTradeInitialRisk(row)
            -- Arm giveback from THIS completed bar before deciding its exit.
            Rt.updateTradeExcursions(row, p)
            local entryRegime = Rt.tradeEntryRegime[row.TradeID]
            local setupAnchor = Rt.tradeSetupAnchor[row.TradeID]
            -- All five entry modes share one open-trade manager. Entry origin is
            -- retained for diagnostics and learning only; it never selects a
            -- different exit model. Use the common base-regime flip and thesis
            -- invalidation rules for every position.

            if row.BS == "B" then
                if Cfg.ExitOnRegimeFlip and Rt.currentBaseRegime == "TRENDING_DOWN"
                    and Scores.trendDownBase >= Cfg.RegimeThreshold + 1 then
                    exitReason = exitReason or "regime flipped bearish"
                end
                if entryRegime == "CHOPPY_RANGE" then
                    if Context.close >= Context.vwap then exitReason = exitReason or "range mean reached" end
                elseif entryRegime == "BREAKOUT_UP" and validNumber(setupAnchor) then
                    if Context.close <= setupAnchor then exitReason = exitReason or "failed bullish breakout" end
                elseif entryRegime == "REVERSAL_BULL" and validNumber(setupAnchor) then
                    if Context.close < setupAnchor then exitReason = exitReason or "bullish reversal structure failed" end
                elseif Cfg.ExitOnThesisInvalidation
                    and Context.close < Context.emaSlow and Context.close < Context.vwap then
                    exitReason = exitReason or "long thesis invalid"
                end
            else
                if Cfg.ExitOnRegimeFlip and Rt.currentBaseRegime == "TRENDING_UP"
                    and Scores.trendUpBase >= Cfg.RegimeThreshold + 1 then
                    exitReason = exitReason or "regime flipped bullish"
                end
                if entryRegime == "CHOPPY_RANGE" then
                    if Context.close <= Context.vwap then exitReason = exitReason or "range mean reached" end
                elseif entryRegime == "BREAKOUT_DOWN" and validNumber(setupAnchor) then
                    if Context.close >= setupAnchor then exitReason = exitReason or "failed bearish breakout" end
                elseif entryRegime == "REVERSAL_BEAR" and validNumber(setupAnchor) then
                    if Context.close > setupAnchor then exitReason = exitReason or "bearish reversal structure failed" end
                elseif Cfg.ExitOnThesisInvalidation
                    and Context.close > Context.emaSlow and Context.close > Context.vwap then
                    exitReason = exitReason or "short thesis invalid"
                end
            end

            -- Smart trade exits: adverse CHOCH and giveback after armed MFE.
            if Cfg.UseSmartTradeManagement and exitReason == nil then
                if Cfg.ExitOnAdverseCHOCH and Context.marketStructureCHOCH then
                    if row.BS == "B" and Context.marketStructureCHOCHDirection == "DOWN" then
                        exitReason = "adverse CHOCH down"
                    elseif row.BS == "S" and Context.marketStructureCHOCHDirection == "UP" then
                        exitReason = "adverse CHOCH up"
                    end
                end
                if exitReason == nil and Cfg.UseGivebackExit then
                    local openRate = tonumber(row.Open)
                    local initialRisk = Rt.tradeInitialRisk[row.TradeID]
                    local snapshot = Rt.tradeAnalytics[row.TradeID] or Rt.tradeAnalytics[tostring(row.TradeID)]
                    local managementPrice = executableExitPrice(row.BS, p)
                    if validNumber(openRate) and validNumber(initialRisk) and initialRisk > 0
                        and validNumber(managementPrice) and snapshot ~= nil then
                        local currentMove = row.BS == "B" and (managementPrice - openRate)
                            or (openRate - managementPrice)
                        local currentR = currentMove / initialRisk
                        local mfeR = (snapshot.mfePrice or 0) / initialRisk
                        if mfeR >= (Cfg.GivebackArmR or 1.5) and currentR <= (Cfg.GivebackFloorR or 0.3) then
                            exitReason = string.format("giveback exit mfeR=%.2f curR=%.2f", mfeR, currentR)
                        end
                    end
                end
            end

            -- Keep the thesis ratchet updated every bar. When enabled, tighten
            -- the real broker stop to the same level. The market-close check is
            -- retained as a last-resort fallback for gaps, rejected edits, or
            -- a price crossing that occurs before the async edit is accepted.
            if Cfg.TrailingStop then
                local thesisStop = updateTrailingStop(row, p)
                if thesisStop ~= nil then
                    updateBrokerStop(row, thesisStop, p)
                    local managementPrice = executableExitPrice(row.BS, p)
                    if managementPrice ~= nil then
                        if row.BS == "B" and managementPrice <= thesisStop then exitReason = exitReason or "ATR/break-even thesis stop" end
                        if row.BS == "S" and managementPrice >= thesisStop then exitReason = exitReason or "ATR/break-even thesis stop" end
                    end
                end
            end

            professionalTradeUpdate(row, p, barsElapsed, exitReason)
            if exitReason ~= nil then closeTrade(row, exitReason) end
        end
        row = enum:next()
    end
    pruneStaleTrailState(openTradeIds)
    if not openOwnSides.B then
        local pending = Rt.fifoClosePending.B
        if type(pending) == "table" and pending.cookie ~= nil then Rt.pendingCloseCookies[pending.cookie] = nil end
        Rt.fifoClosePending.B = nil
    end
    if not openOwnSides.S then
        local pending = Rt.fifoClosePending.S
        if type(pending) == "table" and pending.cookie ~= nil then Rt.pendingCloseCookies[pending.cookie] = nil end
        Rt.fifoClosePending.S = nil
    end
end

-- =========================
-- Diagnostics
-- =========================
-- Minimal protection does not depend on a usable regime/indicator snapshot.
-- Never run entry/thesis classifiers on stale Context during warm-up or outages.
function Rt.manageProtectionOnly(p)
    if not Cfg.AllowTrade or not checkReady("trades") then return end
    local trades = core.host:findTable("trades")
    if trades == nil then return end
    local enum = trades:enumerator()
    local row = enum:next()
    while row ~= nil do
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer and row.QTXT == Cfg.CustomID then
            loadTradeMetadata(row.TradeID)
            local elapsed = barsElapsedInTrade(row, p)
            local stop = Rt.trailStops[row.TradeID]
            local price = executableExitPrice(row.BS, p)
            if elapsed ~= nil and elapsed >= Cfg.MaxBarsInTrade then
                closeTrade(row, "max bars (indicator data unavailable)")
            elseif validNumber(stop) then
                updateBrokerStop(row, stop, p)
                if validNumber(price) and ((row.BS == "B" and price <= stop)
                    or (row.BS == "S" and price >= stop)) then
                    closeTrade(row, "stored protective stop (indicator data unavailable)")
                end
            end
        end
        row = enum:next()
    end
end

local function htfDiagnostic(side)
    if not Cfg.UseHTF then return "DISABLED" end
    -- Only a READY classification may contribute directional evidence.
    if Rt.htfStatus ~= "READY" or Rt.htfLastDate == nil then
        return "NO_DATA:" .. tostring(Rt.htfStatus or "UNKNOWN")
    end
    local stale, age, limit = isHTFStale(closedBarEndDate(Context.p) or Rt.Source:date(Context.p))
    if stale then
        return string.format("STALE:%.1f/%.1fmin", age or -1, limit or -1)
    end
    if side == "B" and Rt.htfTrend == -1 then return "OPPOSED_BEARISH" end
    if side == "S" and Rt.htfTrend == 1 then return "OPPOSED_BULLISH" end
    if Rt.htfTrend == 1 then return "BULLISH_OK" end
    if Rt.htfTrend == -1 then return "BEARISH_OK" end
    return Cfg.HTFAllowNeutral and "NEUTRAL_OK" or "NEUTRAL_BLOCKED"
end

-- Effective trade-type permissions (profile-aware + smart-state aware).
local function tradeTypesEffective()
    local profile = Cfg.TradeTypeProfile or "MANUAL"
    local trend, breakout, range, reversal, fade =
        Cfg.AllowTrendTrades, Cfg.AllowBreakoutTrades, Cfg.AllowRangeTrades,
        Cfg.AllowReversalTrades, Cfg.UseVWAPFade

    if profile == "TREND_FOCUS" then
        trend, breakout, range, reversal, fade = trend, breakout, false, false, false
    elseif profile == "FADE_FOCUS" then
        trend, breakout, range, reversal, fade = false, false, range, reversal, fade
    elseif profile == "AUTO_SMART" and Cfg.UseSmartMarketState then
        local st = tostring(Rt.smartState or "TRANSITION")
        local conf = tonumber(Rt.smartStateConfidence) or 0
        -- AGGRESSIVE keeps permitted families available under a tentative
        -- state classification. Each candidate still needs its own score,
        -- DMI/ADX, geometry and direction edge; explicit OFF always wins.
        local familyConfidence = Cfg.ActivityEffectiveProfile == "AGGRESSIVE" and 65 or 50
        if conf >= familyConfidence then
            if st == "BULL_TREND" or st == "BEAR_TREND" then
                trend, breakout, range, reversal, fade = true, true, false, false, Cfg.UseVWAPFade
            elseif st == "BULL_BREAKOUT" or st == "BEAR_BREAKOUT" then
                trend, breakout, range, reversal, fade = true, true, false, false, false
            elseif st == "RANGE" or st == "QUIET" then
                trend, breakout, range, reversal, fade = false, false, true, Cfg.AllowReversalTrades, true
            elseif st == "FADE_LONG_SETUP" or st == "FADE_SHORT_SETUP" then
                trend, breakout, range, reversal, fade = false, false, true, true, true
            elseif st == "BULL_REVERSAL" or st == "BEAR_REVERSAL" then
                trend, breakout, range, reversal, fade = false, false, true, true, true
            elseif st == "VOLATILE" then
                -- Prefer breakout continuation; suppress casual fades
                trend, breakout, range, reversal, fade = true, true, false, false, false
            end
        end
        -- Always respect hard OFF switches from the user
        trend = trend and Cfg.AllowTrendTrades
        breakout = breakout and Cfg.AllowBreakoutTrades
        range = range and Cfg.AllowRangeTrades
        reversal = reversal and Cfg.AllowReversalTrades
        fade = fade and Cfg.UseVWAPFade
    end
    -- Empty selection is intentional: never restore a state-disabled family.
    return trend, breakout, range, reversal, fade
end

Rt.regimeTradeTypeEnabled = function(regime)
    local trend, breakout, range, reversal, fade = tradeTypesEffective()
    if regime == "TRENDING_UP" or regime == "TRENDING_DOWN" then
        return trend
    elseif regime == "BREAKOUT_UP" or regime == "BREAKOUT_DOWN" then
        return breakout
    elseif regime == "CHOPPY_RANGE" then
        return range
    elseif regime == "REVERSAL_BULL" or regime == "REVERSAL_BEAR" then
        return reversal or fade
    end
    return false
end

local function tradeTypesSummaryText()
    local trend, breakout, range, reversal, fade = tradeTypesEffective()
    local parts = {}
    if trend then parts[#parts + 1] = "TREND" end
    if breakout then parts[#parts + 1] = "BREAKOUT" end
    if range then parts[#parts + 1] = "RANGE" end
    if reversal then parts[#parts + 1] = "REVERSAL" end
    if fade then parts[#parts + 1] = "VWAP_FADE" end
    if #parts == 0 then return "NONE" end
    return table.concat(parts, "+")
end

Rt.directionalTradeRegime = function(regime)
    return regime == "TRENDING_UP" or regime == "TRENDING_DOWN"
        or regime == "BREAKOUT_UP" or regime == "BREAKOUT_DOWN"
end

Rt.directionalRegimeScore = function(regime)
    if regime == "TRENDING_UP" then return Scores.trendUp or 0 end
    if regime == "TRENDING_DOWN" then return Scores.trendDown or 0 end
    if regime == "BREAKOUT_UP" or regime == "BREAKOUT_DOWN" then
        return Scores.breakout or 0
    end
    return 0
end

Rt.strongestCompetingRegime = function(selectedRegime)
    local c = Context
    -- Competitors are alternate *trade-direction / structure* regimes only.
    -- HIGH_VOLATILITY and LOW_VOLATILITY are environment overlays handled by
    -- regime selection and the low-vol trend exception - not opposing sides.
    -- Counting them here blocked almost all trend entries in quiet sessions
    -- (e.g. Sydney/Tokyo) whenever lowVol score exceeded a mild trend score.
    local candidates = {
        {name="TRENDING_UP", score=Scores.trendUp or 0},
        {name="TRENDING_DOWN", score=Scores.trendDown or 0},
        {name="CHOPPY_RANGE", score=Scores.range or 0},
        {name="REVERSAL_BULL", score=Scores.reversalBull or 0},
        {name="REVERSAL_BEAR", score=Scores.reversalBear or 0}
    }
    if Rt.breakoutPresent("B") then candidates[#candidates + 1] = {name="BREAKOUT_UP", score=Scores.breakout or 0} end
    if Rt.breakoutPresent("S") then candidates[#candidates + 1] = {name="BREAKOUT_DOWN", score=Scores.breakout or 0} end

    local bestName, bestScore = "NONE", -math.huge
    for _, candidate in ipairs(candidates) do
        local sameDirectionalFamily =
            (selectedRegime == "TRENDING_UP" and candidate.name == "BREAKOUT_UP")
            or (selectedRegime == "BREAKOUT_UP" and candidate.name == "TRENDING_UP")
            or (selectedRegime == "TRENDING_DOWN" and candidate.name == "BREAKOUT_DOWN")
            or (selectedRegime == "BREAKOUT_DOWN" and candidate.name == "TRENDING_DOWN")
        if candidate.name ~= selectedRegime and not sameDirectionalFamily
            and candidate.score > bestScore then
            bestName, bestScore = candidate.name, candidate.score
        end
    end
    if bestScore == -math.huge then return "NONE", 0 end
    return bestName, bestScore
end

Rt.directionalPolicyStatus = function(side, regime)
    local blockers, passed = {}, {}
    if not Rt.regimeTradeTypeEnabled(regime) then
        blockers[#blockers + 1] = "trade type disabled: " .. tostring(regime)
    else
        passed[#passed + 1] = "trade type enabled: " .. tostring(regime)
    end

    if not Rt.directionalTradeRegime(regime) then return blockers, passed end

    if Cfg.RequireDominantDirectionalRegime then
        local selectedScore = Rt.directionalRegimeScore(regime)
        local competitorName, competitorScore = Rt.strongestCompetingRegime(regime)
        if selectedScore <= competitorScore then
            blockers[#blockers + 1] = string.format(
                "directional regime not dominant: %s %.1f <= %s %.1f",
                tostring(regime), selectedScore, tostring(competitorName), competitorScore)
        else
            passed[#passed + 1] = string.format(
                "directional regime dominant: %s %.1f > %s %.1f",
                tostring(regime), selectedScore, tostring(competitorName), competitorScore)
        end
    else
        passed[#passed + 1] = "directional dominance filter off"
    end

    if regime == "TRENDING_UP" or regime == "TRENDING_DOWN" then
        if not validNumber(Context.adx) or Context.adx < Cfg.MinimumTrendADX then
            blockers[#blockers + 1] = string.format("trend ADX %.1f < %.1f",
                tonumber(Context.adx) or 0, Cfg.MinimumTrendADX)
        else
            passed[#passed + 1] = string.format("trend ADX %.1f >= %.1f",
                Context.adx, Cfg.MinimumTrendADX)
        end
    end

    if Cfg.RequireDirectionalDMIAlignment then
        local dmiAligned = side == "B" and Context.plusDirection > Context.minusDirection
            or side == "S" and Context.minusDirection > Context.plusDirection
        if not dmiAligned then
            blockers[#blockers + 1] = string.format(
                "directional DMI misaligned: DI+=%.1f DI-=%.1f",
                tonumber(Context.plusDirection) or 0, tonumber(Context.minusDirection) or 0)
        else
            passed[#passed + 1] = string.format(
                "directional DMI aligned: DI+=%.1f DI-=%.1f",
                Context.plusDirection, Context.minusDirection)
        end
    else
        passed[#passed + 1] = "directional DMI filter off"
    end
    return blockers, passed
end

local function probabilityRegimeForSide(side, returnCandidates)
    local c = Context
    local trend, breakout, range, reversal, fade = tradeTypesEffective()
    local candidates = {}
    local st = tostring(Rt.smartState or "")
    local stConf = tonumber(Rt.smartStateConfidence) or 0
    local dist = tonumber(c.vwapDistATR) or 0
    local minStretch = Cfg.VWAPFadeMinATR or 2.0
    -- Only treat reversal/fade as a real candidate when stretch exists or generic
    -- reversal is explicitly allowed. Near-VWAP "REVERSAL_*" was ranking first and
    -- then failing geometry (your bar 575 case: 0.09 ATR from VWAP).
    local stretchLong = dist <= -minStretch
    local stretchShort = dist >= minStretch
    if side == "B" then
        if trend then
            local s = Scores.trendUp or 0
            if st == "BULL_TREND" or st == "BULL_BREAKOUT" then s = s + (stConf >= 55 and 2.5 or 1.0) end
            candidates[#candidates + 1] = {name="TRENDING_UP", score=s}
        end
        if (reversal or fade) and (stretchLong or reversal) then
            local s = Scores.reversalBull or 0
            if not stretchLong then s = s - 3.0 end
            if st == "BULL_TREND" or st == "BEAR_TREND" then s = s - 1.5 end
            candidates[#candidates + 1] = {name="REVERSAL_BULL", score=s}
        end
        if breakout and Rt.breakoutPresent("B") then candidates[#candidates + 1] = {name="BREAKOUT_UP", score=Scores.breakout or 0} end
    else
        if trend then
            local s = Scores.trendDown or 0
            if st == "BEAR_TREND" or st == "BEAR_BREAKOUT" then s = s + (stConf >= 55 and 2.5 or 1.0) end
            candidates[#candidates + 1] = {name="TRENDING_DOWN", score=s}
        end
        if (reversal or fade) and (stretchShort or reversal) then
            local s = Scores.reversalBear or 0
            if not stretchShort then s = s - 3.0 end
            if st == "BULL_TREND" or st == "BEAR_TREND" then s = s - 1.5 end
            candidates[#candidates + 1] = {name="REVERSAL_BEAR", score=s}
        end
        if breakout and Rt.breakoutPresent("S") then candidates[#candidates + 1] = {name="BREAKOUT_DOWN", score=Scores.breakout or 0} end
    end
    if range then candidates[#candidates + 1] = {name="CHOPPY_RANGE", score=Scores.range or 0} end
    if returnCandidates then return candidates end
    if #candidates == 0 then return "NONE", 0 end
    local best = candidates[1]
    for i = 2, #candidates do
        if candidates[i].score > best.score then best = candidates[i] end
    end
    return best.name, best.score
end

-- One confirmed pullback event shared by scoring, geometry and setup identity.
-- Reads completed bars only. Continued MA contact never refreshes event age.
function Rt.computeFastMATouchEvidence(side, ruleCfg)
    local cfg = ruleCfg or Cfg
    local c, p = Context, Context.p
    local sign = side == "B" and 1 or -1
    local out = {retested=false, fresh=false, fromTrendSide=false, reclaimed=false,
        candle=false, extensionOK=false, notExtended=false, tightGap=false,
        closeGapATR=math.huge, valid=false, reason="pullback data unavailable"}
    if not validNumber(c.atr) or c.atr <= 0 or not validNumber(c.emaFast)
        or not validNumber(c.close) or not validNumber(c.open) then return out end
    -- Current-bar measurements are independent of historical pullback events.
    -- A missing/expired/invalid event removes event credit, never fabricates a
    -- wide MA gap or erases the current candle, reclaim and extension checks.
    out.closeGapATR = abs(c.close-c.emaFast)/c.atr
    local gapLimit = min(cfg.TrendPullbackMaxCloseATR or 0.55, cfg.ProbabilityPullbackMaxEntryGapATR or 0.60)
    out.tightGap = out.closeGapATR <= gapLimit
    out.reclaimed = sign*(c.close-c.emaFast)/c.atr >= (cfg.PullbackMinReclaimATR or 0.05)
    out.candle = sign*(c.close-c.open)/c.atr >= (cfg.PullbackMinBodyATR or 0.10)
    local dist, rsi = tonumber(c.vwapDistATR), tonumber(c.rsi)
    if not validNumber(dist) or not validNumber(rsi) then out.reason="VWAP/RSI unavailable"; return out end
    out.extensionOK = sign*dist <= min(cfg.TrendMaxExtensionATR or 6, cfg.PullbackMaxVWAPATR or 1.25)
    out.notExtended = out.extensionOK and out.tightGap
    if p == nil or Rt.Source == nil then
        out.reason="pullback history unavailable"; return out
    end
    local first = max(Rt.Source:first()+1, p-(cfg.TrendPullbackLookbackBars or 8))
    local tolerance = cfg.TrendPullbackTouchATR or 0.30
    for i = p, first, -1 do
        local fast, atr, priorFast, priorATR = Ind.emaFast[i], Ind.atr[i], Ind.emaFast[i-1], Ind.atr[i-1]
        local priorMed, priorClose = Ind.emaMed[i-1], Rt.Source.close[i-1]
        local hi, lo = Rt.Source.high[i], Rt.Source.low[i]
        if validNumber(fast) and validNumber(atr) and atr>0
            and validNumber(priorFast) and validNumber(priorATR) and priorATR>0
            and validNumber(priorMed) and validNumber(priorClose)
            and validNumber(hi) and validNumber(lo) then
            local contact = lo <= fast+tolerance*atr and hi >= fast-tolerance*atr
            local approach = sign*(priorClose-priorFast) > tolerance*priorATR
                and sign*(priorFast-priorMed)>0
            local extreme = side == "B" and lo or hi
            local retraced = sign*(priorClose-extreme) >= (cfg.PullbackMinRetraceATR or 0.20)*priorATR
            if contact and approach and retraced then
                out.retested, out.fromTrendSide = true, true
                out.retestAge, out.touchPeriod = p-i, i
                out.touchDate = Rt.Source:date(i)
                -- Reject invalidated history; never resurrect an older event.
                for j=i,p do
                    local close, ma, barATR = Rt.Source.close[j], Ind.emaFast[j], Ind.atr[j]
                    if not validNumber(close) or not validNumber(ma) or not validNumber(barATR) or barATR<=0 then
                        out.reason="incomplete pullback history"; return out
                    end
                    if sign*(close-ma) < -(cfg.PullbackMaxAdverseATR or 0.75)*barATR then
                        out.reason="pullback invalidated by adverse close"; return out
                    end
                end
                break
            end
        end
    end
    if not out.retested then out.reason="no directional approach and retracement into MA band"; return out end
    out.fresh = out.retestAge <= (cfg.PullbackMaxAgeBars or 5)
    local rsiOK = side == "B" and rsi <= (cfg.PullbackMaxLongRSI or 68)
        or side == "S" and rsi >= (cfg.PullbackMinShortRSI or 32)
    local failures = {}
    if not out.fresh then failures[#failures+1]="touch expired" end
    if not out.reclaimed then failures[#failures+1]="reclaim too small" end
    if not out.candle then failures[#failures+1]="resumption body too weak" end
    if not out.tightGap then failures[#failures+1]="entry too far from MA" end
    if not out.extensionOK then failures[#failures+1]="VWAP extension limit" end
    if not rsiOK then failures[#failures+1]="RSI extension limit" end
    out.valid = #failures==0
    out.reason = out.valid and "directional approach -> retracement -> confirmed resumption"
        or table.concat(failures, "; ")
    return out
end

-- Read-only evidence table, reused across candidates and diagnostics.
local function probabilityFastMATouchEvidence(side)
    Rt.fastTouchCache = Rt.fastTouchCache or {}
    if Rt.fastTouchCache[side] == nil then
        Rt.fastTouchCache[side] = Rt.computeFastMATouchEvidence(side)
    end
    return Rt.fastTouchCache[side]
end

-- Probability Edge Engine v8.4.7 — evidence score 0..100 (not a calibrated win %).
-- Buckets: direction20 + structure20 + location20 + htf15 + momentum15 + env10
-- + smartDelta[-12..+12]. Location is regime-aware so trend no longer scores
-- "buy high" the same as a real pullback.
local function probabilityScoreBreakdown(side, regime, forRisk)
    local cfg = forRisk and Cfg.ActivityBase or Cfg
    local c = Context
    local st = Rt.marketStructure or {}
    local parts = {direction=0, structure=0, location=0, htf=0, momentum=0, environment=0}
    local touch = forRisk and Rt.computeFastMATouchEvidence(side, cfg)
        or probabilityFastMATouchEvidence(side)
    local isBuy = side == "B"
    local directionalTrend = isBuy and (Scores.trendUp or 0) or (Scores.trendDown or 0)
    local reversalScore = isBuy and (Scores.reversalBull or 0) or (Scores.reversalBear or 0)
    local opposingReversalScore = isBuy and (Scores.reversalBear or 0) or (Scores.reversalBull or 0)
    local directionalBreak = Rt.breakoutPresent(side)
    local dist = tonumber(c.vwapDistATR) or 0
    local rsi = tonumber(c.rsi) or 50
    local rangePos = tonumber(c.rangePosition) or 0.5
    local bullCandle = c.close ~= nil and c.open ~= nil and c.close > c.open
    local bearCandle = c.close ~= nil and c.open ~= nil and c.close < c.open
    local sideCandle = (isBuy and bullCandle) or ((not isBuy) and bearCandle)
    local directionalMomentum = isBuy and (c.momentumATR or 0) > 0
        or (not isBuy and (c.momentumATR or 0) < 0)

    -- 1) DIRECTION / REGIME: 20
    if regime == "CHOPPY_RANGE" then
        parts.direction = 10.0 * clamp((Scores.range or 0) / 10.0, 0, 1)
        local edge = isBuy and (1.0 - rangePos) or rangePos
        parts.direction = parts.direction + 6.0 * clamp(edge, 0, 1)
        if sideCandle then parts.direction = parts.direction + 2 end
        if (c.adx or 0) < 20 or (c.adxPct or 0.5) <= 0.4 then
            parts.direction = parts.direction + 2
        end
        -- Mid-range has no directional edge for mean-reversion
        if abs(rangePos - 0.5) < 0.15 then
            parts.direction = parts.direction - 4
        end
    elseif string.sub(regime, 1, 8) == "REVERSAL" then
        parts.direction = 12.0 * clamp(reversalScore / 10.0, 0, 1)
        local stretched = isBuy and dist < -0.35 or (not isBuy and dist > 0.35)
        if stretched then parts.direction = parts.direction + 4 end
        if isBuy and rsi < 45 or (not isBuy and rsi > 55) then
            parts.direction = parts.direction + 2
        end
        if isBuy and c.rejectionBull or (not isBuy and c.rejectionBear) then
            parts.direction = parts.direction + 2
        end
        -- Near VWAP "reversals" are not real fades
        if abs(dist) < 0.35 then
            parts.direction = parts.direction - 5
        end
    else
        -- Trend / breakout family
        parts.direction = 10.0 * clamp(directionalTrend / 10.0, 0, 1)
        if string.sub(regime, 1, 8) == "BREAKOUT" then
            parts.direction = parts.direction + 8.0 * clamp((Scores.breakout or 0) / 10.0, 0, 1) * 0.35
        end
        local fullMA = isBuy and c.emaFast > c.emaMed and c.emaMed > c.emaSlow
            or (not isBuy and c.emaFast < c.emaMed and c.emaMed < c.emaSlow)
        local fastMA = isBuy and c.emaFast >= c.emaMed or (not isBuy and c.emaFast <= c.emaMed)
        if fullMA then parts.direction = parts.direction + 4
        elseif fastMA then parts.direction = parts.direction + 2 end
        local dmiAligned = isBuy and c.plusDirection > c.minusDirection
            or (not isBuy and c.minusDirection > c.plusDirection)
        if dmiAligned then parts.direction = parts.direction + 3 end
        if directionalBreak then parts.direction = parts.direction + 2 end
        -- Counter-trend reversal pressure softens trend direction
        if opposingReversalScore >= (cfg.ReversalThreshold or 4) then
            parts.direction = parts.direction - 2
        end
    end
    parts.direction = clamp(parts.direction, 0, 20)

    -- 2) CONFIRMED MARKET STRUCTURE: 20
    local wantedBias = isBuy and "BULLISH" or "BEARISH"
    local opposingBias = isBuy and "BEARISH" or "BULLISH"
    if st.bias == wantedBias then
        parts.structure = parts.structure + 8
        if (st.confidence or 0) >= 70 then parts.structure = parts.structure + 2 end
    end
    local labelsUsable = not st.broken and not st.ambiguous and st.bias ~= "UNAVAILABLE"
    local highLabel = labelsUsable and not st.highStale and st.lastHigh ~= nil and st.lastHigh.label or nil
    local lowLabel = labelsUsable and not st.lowStale and st.lastLow ~= nil and st.lastLow.label or nil
    if isBuy then
        if highLabel == "HH" then parts.structure = parts.structure + 4 end
        if lowLabel == "HL" then parts.structure = parts.structure + 4 end
        if st.bosUp then parts.structure = parts.structure + 3 end
        if st.choch and st.chochDirection == "UP" then parts.structure = parts.structure + 1 end
        if st.choch and st.chochDirection == "DOWN" then parts.structure = parts.structure - 6 end
    else
        if highLabel == "LH" then parts.structure = parts.structure + 4 end
        if lowLabel == "LL" then parts.structure = parts.structure + 4 end
        if st.bosDown then parts.structure = parts.structure + 3 end
        if st.choch and st.chochDirection == "DOWN" then parts.structure = parts.structure + 1 end
        if st.choch and st.chochDirection == "UP" then parts.structure = parts.structure - 6 end
    end
    if st.bias == opposingBias then parts.structure = parts.structure - 5 end
    if st.phase == "TRANSITION" then parts.structure = parts.structure - 2 end
    if st.stale then parts.structure = min(parts.structure, 6) end
    parts.structure = clamp(parts.structure, 0, 20)

    -- 3) ENTRY LOCATION: 20 (regime-specific — the main quality fix)
    if regime == "CHOPPY_RANGE" then
        local edge = isBuy and (1.0 - rangePos) or rangePos
        parts.location = 10.0 * clamp(edge, 0, 1)
        -- VWAP stretch toward the mean-reversion side
        if isBuy and dist <= -0.35 then
            parts.location = parts.location + clamp((-dist) / 1.5, 0, 1) * 6
        elseif not isBuy and dist >= 0.35 then
            parts.location = parts.location + clamp(dist / 1.5, 0, 1) * 6
        end
        if sideCandle or (isBuy and c.rejectionBull) or (not isBuy and c.rejectionBear) then
            parts.location = parts.location + 3
        end
        if abs(rangePos - 0.5) < 0.12 and abs(dist) < 0.40 then
            parts.location = parts.location - 6
        end
    elseif string.sub(regime, 1, 8) == "REVERSAL" then
        local minStretch = cfg.VWAPFadeMinATR or 2.0
        if isBuy then
            parts.location = parts.location + clamp((-dist) / max(minStretch, 0.5), 0, 1) * 10
            if rsi <= (cfg.VWAPFadeRSILow or 30) then parts.location = parts.location + 4 end
            if c.rejectionBull then parts.location = parts.location + 4 end
            if bullCandle then parts.location = parts.location + 2 end
        else
            parts.location = parts.location + clamp(dist / max(minStretch, 0.5), 0, 1) * 10
            if rsi >= (cfg.VWAPFadeRSIHigh or 70) then parts.location = parts.location + 4 end
            if c.rejectionBear then parts.location = parts.location + 4 end
            if bearCandle then parts.location = parts.location + 2 end
        end
        if abs(dist) < 0.50 then parts.location = parts.location - 8 end
    else
        -- TREND / BREAKOUT: reward pullback quality; punish chase
        if touch.fresh and touch.fromTrendSide then
            parts.location = parts.location + 8
        elseif touch.fresh then
            parts.location = parts.location + 5
        elseif touch.retested then
            parts.location = parts.location + 2
        end
        if touch.tightGap and touch.reclaimed then
            parts.location = parts.location + 5
        elseif touch.tightGap then
            parts.location = parts.location + 2
        elseif touch.closeGapATR > (cfg.ProbabilityPullbackMaxEntryGapATR or 0.60) then
            parts.location = parts.location - 4
        end
        if touch.notExtended then
            parts.location = parts.location + 4
        elseif not touch.extensionOK then
            parts.location = parts.location - 5
        end
        -- Side-of-VWAP: mild bonus only when not extended
        local vwapAligned = isBuy and c.close >= c.vwap or (not isBuy and c.close <= c.vwap)
        if vwapAligned and touch.notExtended then
            parts.location = parts.location + 3
        elseif isBuy and dist > 1.50 or (not isBuy and dist < -1.50) then
            parts.location = parts.location - 4
        end
        if string.sub(regime, 1, 8) == "BREAKOUT" and directionalBreak then
            parts.location = parts.location + 3
        end
    end
    parts.location = clamp(parts.location, 0, 20)

    -- 4) HTF ALIGNMENT: 15
    if not cfg.UseHTF then
        parts.htf = 7
    else
        local htfReady = Rt.htfStatus == "READY" and Rt.htfLastDate ~= nil
        local htfStale = false
        if htfReady and Context.p ~= nil and Rt.Source ~= nil then
            htfStale = isHTFStale(closedBarEndDate(Context.p) or Rt.Source:date(Context.p))
        end
        if not htfReady or htfStale then
            parts.htf = 0
        elseif Rt.htfTrend == (isBuy and 1 or -1) then
            parts.htf = 15
            if (Rt.htfStrength or 0) >= 0.6 then parts.htf = 15 end
        elseif Rt.htfTrend == 0 then
            parts.htf = cfg.HTFAllowNeutral and 6 or 2
        else
            parts.htf = 0
        end
    end

    -- 5) MOMENTUM / TRIGGER: 15 (regime-aware)
    if regime == "CHOPPY_RANGE" or string.sub(regime, 1, 8) == "REVERSAL" then
        -- Mean-reversion: want exhaustion + turn, not trend momentum
        if isBuy and (c.momentumATR or 0) > -0.15 and (c.momentumATR or 0) < 0.85 then
            parts.momentum = parts.momentum + 3
        elseif not isBuy and (c.momentumATR or 0) < 0.15 and (c.momentumATR or 0) > -0.85 then
            parts.momentum = parts.momentum + 3
        end
        if sideCandle then parts.momentum = parts.momentum + 4 end
        if isBuy and c.rejectionBull or (not isBuy and c.rejectionBear) then
            parts.momentum = parts.momentum + 4
        end
        if isBuy and rsi <= 40 or (not isBuy and rsi >= 60) then
            parts.momentum = parts.momentum + 3
        end
        if (c.adx or 0) < 22 then parts.momentum = parts.momentum + 1 end
    else
        if directionalMomentum then parts.momentum = parts.momentum + 4 end
        local dmiRatio = isBuy and safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
            or safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
        if dmiRatio >= (cfg.EarlyBreakoutMinDMIRatio or 1.15) then
            parts.momentum = parts.momentum + 4
        elseif dmiRatio > 1.0 then
            parts.momentum = parts.momentum + 2
        end
        if touch.candle then parts.momentum = parts.momentum + 2 end
        if touch.reclaimed and touch.fresh then parts.momentum = parts.momentum + 3
        elseif touch.reclaimed then parts.momentum = parts.momentum + 1 end
        if (c.adx or 0) >= 22 or (c.adxPct or 0) >= 0.55 then
            parts.momentum = parts.momentum + 2
        end
        if (tonumber(c.efficiency) or 0) >= 0.45 and directionalMomentum then
            parts.momentum = parts.momentum + 1
        end
    end
    parts.momentum = clamp(parts.momentum, 0, 15)

    -- 6) SESSION / ENVIRONMENT: 10
    local session = tostring(Rt.activeMarketSession or "OFF_HOURS")
    local sessionPoints = 0
    if session == "LONDON_NEW_YORK_OVERLAP" then sessionPoints = 9
    elseif session == "LONDON" then sessionPoints = 8
    elseif session == "NEW_YORK" or session == "TOKYO_LONDON_OVERLAP" then sessionPoints = 7
    elseif session == "TOKYO" then sessionPoints = 4
    elseif session == "SYDNEY_TOKYO_OVERLAP" then sessionPoints = 3
    elseif session == "SYDNEY" then sessionPoints = 2 end
    parts.environment = sessionPoints
    local candleOK = (c.rangeATR or 0) <= (cfg.LargeCandleATR or 3.5)
    local volatilityOK = (Scores.lowVol or 0) < 7 and (Scores.highVol or 0) < 8
    local breakoutVolOK = string.sub(regime, 1, 8) == "BREAKOUT" and (Scores.highVol or 0) >= 5
    if candleOK and (volatilityOK or breakoutVolOK) then
        parts.environment = parts.environment + 1
    end
    -- Spread cost soft penalty inside environment
    local spread = spreadPips(Rt.processingPeriod)
    local maxSp = max(cfg.MaxSpreadPips or 1, 0.0001)
    if spread > maxSp * 0.75 then
        parts.environment = parts.environment - 2
    end
    parts.environment = clamp(parts.environment, 0, 10)

    -- Smart Evidence: coherence, agreement, State AI, pulse, anti-chase
    parts.smartDelta = 0
    parts.smartNote = "off"
    if cfg.UseSmartEvidence then
        local delta = 0
        local notes = {}
        if parts.direction >= 14 and parts.structure < 4 then
            delta = delta - 4
            notes[#notes + 1] = "dirWithoutStructure-4"
        end
        if parts.structure >= 14 and parts.momentum < 4 then
            delta = delta - 3
            notes[#notes + 1] = "structureWithoutMomentum-3"
        end
        if parts.direction >= 14 and parts.location < 5 then
            delta = delta - 4
            notes[#notes + 1] = "dirWithoutLocation-4"
        end
        -- Trend-specific anti-chase
        if string.sub(regime, 1, 8) == "TRENDING" or string.sub(regime, 1, 8) == "BREAKOUT" then
            if isBuy and rsi >= 70 then
                delta = delta - 4
                notes[#notes + 1] = "rsiOverbought-4"
            elseif not isBuy and rsi <= 30 then
                delta = delta - 4
                notes[#notes + 1] = "rsiOversold-4"
            end
            if not touch.notExtended then
                delta = delta - 3
                notes[#notes + 1] = "chaseExtension-3"
            end
            if touch.closeGapATR > (cfg.ProbabilityPullbackMaxEntryGapATR or 0.60) then
                delta = delta - 3
                notes[#notes + 1] = "wideMAGap-3"
            end
        end
        if regime == "REVERSAL_BULL" or regime == "REVERSAL_BEAR" or regime == "CHOPPY_RANGE" then
            local minStretch = cfg.VWAPFadeMinATR or 2.0
            if isBuy and dist <= -minStretch and rsi <= (cfg.VWAPFadeRSILow or 30) then
                delta = delta + 3
                notes[#notes + 1] = "fadeLongFit+3"
            elseif not isBuy and dist >= minStretch and rsi >= (cfg.VWAPFadeRSIHigh or 70) then
                delta = delta + 3
                notes[#notes + 1] = "fadeShortFit+3"
            elseif abs(dist) < 0.40 then
                delta = delta - 3
                notes[#notes + 1] = "fadeNoStretch-3"
            end
        end
        local agreement = 0
        if parts.direction >= 12 then agreement = agreement + 1 end
        if parts.structure >= 10 then agreement = agreement + 1 end
        if parts.location >= 10 then agreement = agreement + 1 end
        if parts.momentum >= 8 then agreement = agreement + 1 end
        if parts.htf >= 12 then agreement = agreement + 1 end
        if parts.environment >= 6 then agreement = agreement + 1 end
        if agreement >= 4 then
            local bonus = min(cfg.SmartAgreementBonusMax or 6, 1.5 + (agreement - 3) * 1.5)
            delta = delta + bonus
            notes[#notes + 1] = string.format("agreement+%g", bonus)
        elseif agreement <= 1 and parts.direction >= 12 then
            delta = delta - 3
            notes[#notes + 1] = "isolatedDirection-3"
        end
        local margin = tonumber(Rt.regimeEffectiveMargin) or 0
        if margin > 0 and margin < (cfg.RegimeConfidenceMargin or 1) then
            delta = delta - 2
            notes[#notes + 1] = "thinMargin-2"
        end
        if cfg.ProbabilityUseStateAI and cfg.UseSmartMarketState then
            local stConf = tonumber(Rt.smartStateConfidence) or 0
            local stBias = tostring(Rt.smartStateBias or "NEUTRAL")
            local sideBias = isBuy and "BULL" or "BEAR"
            local boostMax = cfg.StateAIScoreBoostMax or 6
            if stBias == sideBias and stConf >= 60 then
                local boost = clamp((stConf - 55) / 40 * boostMax, 1, boostMax)
                delta = delta + boost
                notes[#notes + 1] = string.format("stateAlign+%.0f", boost)
            elseif stBias ~= "NEUTRAL" and stBias ~= sideBias and stConf >= 65 then
                delta = delta - 4
                notes[#notes + 1] = "stateOppose-4"
            elseif stConf < 45 then
                delta = delta - 2
                notes[#notes + 1] = "stateWeak-2"
            end
        end
        -- Live pulse: hostile tape softens score; friendly tape mild boost
        local pulse = Rt.livePulse
        if type(pulse) == "table" and validNumber(pulse.friendliness) then
            if pulse.friendliness < 0.35 then
                delta = delta - 3
                notes[#notes + 1] = "pulseHostile-3"
            elseif pulse.friendliness >= 0.70 and parts.location >= 10 then
                delta = delta + 2
                notes[#notes + 1] = "pulseFriendly+2"
            end
        end
        parts.smartDelta = clamp(delta, -12, 12)
        parts.smartNote = #notes > 0 and table.concat(notes, ",") or "neutral"
    end

    local total = parts.direction + parts.structure + parts.location + parts.htf
        + parts.momentum + parts.environment + (parts.smartDelta or 0)
    return parts, clamp(total, 0, 100), touch
end

local function smartRequiredScore(side, regime, htf, parts, forRisk)
    local cfg = forRisk and Cfg.ActivityBase or Cfg
    local required = cfg.ProbabilityScoreMin or 52
    if not cfg.UseSmartEvidence then return required, "base" end
    local add = 0
    local notes = {}
    local htfOpposed = type(htf) == "string"
        and (string.sub(htf, 1, 7) == "OPPOSED")
    if htfOpposed and cfg.HTFOppositionMode ~= "BLOCK" then
        add = add + (cfg.SmartHTFOpposedScoreAdd or 0)
        notes[#notes + 1] = "htfOpposed"
    end
    local margin = tonumber(Rt.regimeEffectiveMargin) or 0
    if margin > 0 and margin < (cfg.RegimeConfidenceMargin or 1) then
        add = add + (cfg.SmartThinMarginScoreAdd or 0)
        notes[#notes + 1] = "thinMargin"
    end
    if (Scores.highVol or 0) >= 7 then
        add = add + (cfg.SmartHighVolScoreAdd or 0)
        notes[#notes + 1] = "highVol"
    end
    -- State AI: raise the bar when state confidence is weak or bias opposes
    if cfg.ProbabilityUseStateAI and cfg.UseSmartMarketState then
        local stConf = tonumber(Rt.smartStateConfidence) or 0
        local stBias = tostring(Rt.smartStateBias or "NEUTRAL")
        local sideBias = side == "B" and "BULL" or "BEAR"
        if stConf > 0 and stConf < 48 then
            add = add + (cfg.StateAILowConfScoreAdd or 4)
            notes[#notes + 1] = "stateLowConf"
        end
        if stBias ~= "NEUTRAL" and stBias ~= sideBias and stConf >= 60 then
            add = add + 3
            notes[#notes + 1] = "stateOpposeBar"
        end
        -- Slightly lower bar when state strongly aligns (easier pass for clean setups)
        if stBias == sideBias and stConf >= 75 then
            add = add - 2
            notes[#notes + 1] = "stateStrongAlign"
        end
    end
    -- Reversal/fade: slightly higher bar (mean-reversion edge is thinner)
    if regime == "REVERSAL_BULL" or regime == "REVERSAL_BEAR" then
        add = add + 2
        notes[#notes + 1] = "reversalBar"
    end
    -- Live pulse: raise/lower the bar to match what the market is doing now
    local pulse = Rt.livePulse
    if type(pulse) == "table" and validNumber(pulse.scoreAdd) then
        add = add + pulse.scoreAdd
        if pulse.note and pulse.note ~= "neutral" then
            notes[#notes + 1] = "pulse:" .. tostring(pulse.note)
        end
    end
    return math.max(required + add, (cfg.ProbabilityScoreMin or 52) - 2),
        #notes > 0 and table.concat(notes, "+") or "base"
end

local function smartRequiredEdge(leaderSide, longHtf, shortHtf)
    local edgeMin = Cfg.ProbabilityEdgeMin or 5
    if not Cfg.UseSmartEvidence then return edgeMin end
    local leaderHtf = leaderSide == "B" and longHtf or shortHtf
    if type(leaderHtf) == "string" and string.sub(leaderHtf, 1, 7) == "OPPOSED"
        and Cfg.HTFOppositionMode ~= "BLOCK" then
        edgeMin = edgeMin + (Cfg.SmartHTFOpposedEdgeAdd or 0)
    end
    if Cfg.ProbabilityUseStateAI and Cfg.UseSmartMarketState then
        local stConf = tonumber(Rt.smartStateConfidence) or 0
        if stConf > 0 and stConf < 50 then
            edgeMin = edgeMin + 2
        end
    end
    local pulse = Rt.livePulse
    if type(pulse) == "table" and validNumber(pulse.edgeAdd) then
        edgeMin = edgeMin + pulse.edgeAdd
    end
    return edgeMin
end

local function evidenceCoherenceStatus(side, regime, parts)
    if not Cfg.UseSmartEvidence or not Cfg.RequireEvidenceCoherence then
        return true, "coherence off"
    end
    local directional = regime == "TRENDING_UP" or regime == "TRENDING_DOWN"
        or regime == "BREAKOUT_UP" or regime == "BREAKOUT_DOWN"
    if not directional then return true, "coherence N/A (non-directional regime)" end
    local fails = {}
    if (parts.direction or 0) < (Cfg.MinBucketDirection or 0) then
        fails[#fails + 1] = string.format("direction %.1f<%.1f", parts.direction or 0, Cfg.MinBucketDirection or 0)
    end
    if (parts.structure or 0) < (Cfg.MinBucketStructure or 0) then
        fails[#fails + 1] = string.format("structure %.1f<%.1f", parts.structure or 0, Cfg.MinBucketStructure or 0)
    end
    if (parts.location or 0) < (Cfg.MinBucketLocation or 0) then
        fails[#fails + 1] = string.format("location %.1f<%.1f", parts.location or 0, Cfg.MinBucketLocation or 0)
    end
    if (parts.momentum or 0) < (Cfg.MinBucketMomentum or 0) then
        fails[#fails + 1] = string.format("momentum %.1f<%.1f", parts.momentum or 0, Cfg.MinBucketMomentum or 0)
    end
    if #fails > 0 then return false, "bucket mins failed: " .. table.concat(fails, "; ") end
    return true, "bucket mins passed"
end

local function earlyTrendBreakoutStatus(side)
    local c = Context
    -- Gate on the bar-global trend+breakout alliance from detectMarketRegime,
    -- not on probabilityRegimeForSide(side). A side may still surface TRENDING_*
    -- as its local best candidate while the overall winner (and compatibility)
    -- points the other way; early breakout stays off in that case by design.
    local compatibleSide = Rt.regimeCompatible and Rt.regimeCompatibleSide or nil
    local _, breakoutAllowed = tradeTypesEffective()
    local enabled = Cfg.UseEarlyTrendBreakout and breakoutAllowed and compatibleSide == side
    local closeGapATR = safeDiv(abs(c.close - c.emaFast), c.atr, math.huge)
    local closeNear = closeGapATR <= Cfg.EarlyBreakoutMaxFastMAGapATR
    local adxOK = c.adx >= Cfg.EarlyBreakoutMinADX

    if side == "B" then
        local swingBreak = c.breakHigh
        local momentumOK = c.momentumATR >= Cfg.EarlyBreakoutMinMomentumATR
        local dmiRatio = safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
        local dmiOK = dmiRatio >= Cfg.EarlyBreakoutMinDMIRatio
        local candleOK = c.close > c.open
        local maAligned = c.emaFast >= c.emaMed
        local vwapOK = c.vwapDistATR >= 0
            and c.vwapDistATR <= Cfg.EarlyBreakoutMaxVWAPExtensionATR
        local allowed = enabled and swingBreak and momentumOK and dmiOK and adxOK
            and candleOK and maAligned and closeNear and vwapOK
        return allowed, string.format(
            "earlyBreakoutLong(enabled=%s globalCompat=%s breakH=%s mom=%.2f/%.2f=%s DMIratio=%.2f/%.2f=%s ADX=%.1f/%.1f=%s bull=%s MAalign=%s closeGap=%.2f/%.2f=%s VWAP=%.2f/[0,%.2f]=%s)",
            yn(enabled), tostring(compatibleSide or "none"), yn(swingBreak),
            c.momentumATR, Cfg.EarlyBreakoutMinMomentumATR,
            yn(momentumOK), dmiRatio, Cfg.EarlyBreakoutMinDMIRatio, yn(dmiOK),
            c.adx, Cfg.EarlyBreakoutMinADX, yn(adxOK), yn(candleOK), yn(maAligned),
            closeGapATR, Cfg.EarlyBreakoutMaxFastMAGapATR, yn(closeNear),
            c.vwapDistATR, Cfg.EarlyBreakoutMaxVWAPExtensionATR, yn(vwapOK))
    end

    local swingBreak = c.breakLow
    local momentumOK = c.momentumATR <= -Cfg.EarlyBreakoutMinMomentumATR
    local dmiRatio = safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
    local dmiOK = dmiRatio >= Cfg.EarlyBreakoutMinDMIRatio
    local candleOK = c.close < c.open
    local maAligned = c.emaFast <= c.emaMed
    local vwapOK = c.vwapDistATR <= 0
        and c.vwapDistATR >= -Cfg.EarlyBreakoutMaxVWAPExtensionATR
    local allowed = enabled and swingBreak and momentumOK and dmiOK and adxOK
        and candleOK and maAligned and closeNear and vwapOK
    return allowed, string.format(
        "earlyBreakoutShort(enabled=%s globalCompat=%s breakL=%s mom=%.2f/min=-%.2f=%s DMIratio=%.2f/%.2f=%s ADX=%.1f/%.1f=%s bear=%s MAalign=%s closeGap=%.2f/%.2f=%s VWAP=%.2f/[-%.2f,0]=%s)",
        yn(enabled), tostring(compatibleSide or "none"), yn(swingBreak),
        c.momentumATR, Cfg.EarlyBreakoutMinMomentumATR,
        yn(momentumOK), dmiRatio, Cfg.EarlyBreakoutMinDMIRatio, yn(dmiOK),
        c.adx, Cfg.EarlyBreakoutMinADX, yn(adxOK), yn(candleOK), yn(maAligned),
        closeGapATR, Cfg.EarlyBreakoutMaxFastMAGapATR, yn(closeNear),
        c.vwapDistATR, Cfg.EarlyBreakoutMaxVWAPExtensionATR, yn(vwapOK))
end

function Rt.computeFastMAPullbackStatus(side)
    local t = probabilityFastMATouchEvidence(side)
    return t.valid == true, string.format(
        "pullback%s valid=%s age=%s/%d approach=%s reclaim=%s body=%s gap=%.2f/%.2fATR VWAPcap=%.2f RSIlimit=%.0f | %s",
        side, yn(t.valid), t.retestAge ~= nil and tostring(t.retestAge) or "NA", Cfg.PullbackMaxAgeBars or 5,
        yn(t.fromTrendSide), yn(t.reclaimed), yn(t.candle), t.closeGapATR,
        min(Cfg.TrendPullbackMaxCloseATR or 0.55, Cfg.ProbabilityPullbackMaxEntryGapATR or 0.60),
        min(Cfg.TrendMaxExtensionATR or 6, Cfg.PullbackMaxVWAPATR or 1.25),
        side=="B" and (Cfg.PullbackMaxLongRSI or 68) or (Cfg.PullbackMinShortRSI or 32), t.reason)
end

-- Cache only within this immutable closed-bar context, never across bars.
local function fastMAPullbackStatus(side)
    Rt.pullbackCache = Rt.pullbackCache or {}
    local cached = Rt.pullbackCache[side]
    if cached == nil then
        local ok, description = Rt.computeFastMAPullbackStatus(side)
        cached = {ok=ok, description=description}
        Rt.pullbackCache[side] = cached
    end
    return cached.ok, cached.description
end

-- VWAP fade: mean-revert from extreme stretch. Long = stretched below VWAP +
-- oversold RSI + bullish rejection; short is the mirror. Partial snapback is the
-- intended thesis; actual broker targets use the selected regime RR times stop.
local function vwapFadeStatus(side)
    local _, _, _, _, fadeAllowed = tradeTypesEffective()
    if not fadeAllowed then
        return false, "VWAP fade disabled by switch/profile/state"
    end
    local c = Context
    local dist = tonumber(c.vwapDistATR) or 0
    local rsi = tonumber(c.rsi) or 50
    local adx = tonumber(c.adx) or 0
    local minStretch = Cfg.VWAPFadeMinATR or 2.0
    local maxAdx = Cfg.VWAPFadeMaxADX or 0
    if maxAdx > 0 and adx > maxAdx then
        return false, string.format("VWAP fade blocked: ADX %.1f > max %.1f", adx, maxAdx)
    end
    if side == "B" then
        local stretch = dist <= -minStretch
        local rsiOK = rsi <= (Cfg.VWAPFadeRSILow or 30)
        local reject = (not Cfg.VWAPFadeRequireRejection) or c.rejectionBull
        local ok = stretch and rsiOK and reject
        return ok, string.format(
            "VWAP_FADE_LONG stretch=%.2f<=-%.2fATR=%s RSI=%.1f<=%.0f=%s rejection=%s",
            dist, minStretch, yn(stretch), rsi, Cfg.VWAPFadeRSILow or 30, yn(rsiOK), yn(reject))
    end
    local stretch = dist >= minStretch
    local rsiOK = rsi >= (Cfg.VWAPFadeRSIHigh or 70)
    local reject = (not Cfg.VWAPFadeRequireRejection) or c.rejectionBear
    local ok = stretch and rsiOK and reject
    return ok, string.format(
        "VWAP_FADE_SHORT stretch=%.2f>=%.2fATR=%s RSI=%.1f>=%.0f=%s rejection=%s",
        dist, minStretch, yn(stretch), rsi, Cfg.VWAPFadeRSIHigh or 70, yn(rsiOK), yn(reject))
end

-- CHOPPY_RANGE geometry (v8.4.3+): multi-path mean-reversion instead of a
-- single rigid AND of edge+VWAP+RSI+candle (which almost never fired on GER30 M1
-- when price oscillates near VWAP). Mid-range is still blocked.
local function rangeGeometryStatus(side)
    local c = Context
    local edgeFrac = Cfg.RangeEdgeFraction or 0.35
    if edgeFrac < 0.10 then edgeFrac = 0.10 end
    if edgeFrac > 0.49 then edgeFrac = 0.49 end
    local pos = tonumber(c.rangePosition) or 0.5
    local dist = tonumber(c.vwapDistATR) or 0
    local rsi = tonumber(c.rsi) or 50
    local atr = tonumber(c.atr) or 0
    local bull = c.close ~= nil and c.open ~= nil and c.close > c.open
    local bear = c.close ~= nil and c.open ~= nil and c.close < c.open
    local rejectBull = c.rejectionBull and true or false
    local rejectBear = c.rejectionBear and true or false
    -- Soft band: slightly inside the edge when confirmation is strong
    local soft = edgeFrac + 0.08
    if soft > 0.50 then soft = 0.50 end

    if side == "B" then
        local atEdge = pos <= edgeFrac
        local nearEdge = pos <= soft
        local notUpper = pos <= 0.50
        -- Path 1: classic edge bounce (softer VWAP/RSI than legacy -0.5 / 45)
        local pathEdge = atEdge and dist <= -0.30 and rsi <= 48 and (bull or rejectBull)
        -- Path 2: deep swing edge with only mild discount + bullish close
        local pathDeep = pos <= edgeFrac * 0.85 and dist <= -0.20 and bull and rsi <= 52
        -- Path 3: VWAP-centric range fade (may sit mid-lower half, needs stretch)
        local pathVwap = notUpper and dist <= -0.70 and rsi <= 42 and (bull or rejectBull)
        -- Path 4: wick rejection at edge even if body is mixed
        local pathReject = atEdge and rejectBull and dist <= 0.05 and rsi <= 50
        -- Path 5: full VWAP fade module when enabled
        local fadeOK, fadeText = false, "fade off"
        if Cfg.UseVWAPFade then
            fadeOK, fadeText = vwapFadeStatus("B")
            if fadeOK and not notUpper then
                fadeOK = false
                fadeText = "VWAP_FADE_LONG blocked: upper half of range"
            end
        end
        local fbOK, fbText = KeyLevels.falseBreakoutStatus("B")
        local ok = pathEdge or pathDeep or pathVwap or pathReject or fadeOK or fbOK
        local path = pathEdge and "EDGE" or (pathDeep and "DEEP" or (pathVwap and "VWAP"
            or (pathReject and "REJECT" or (fadeOK and "FADE" or (fbOK and "KEY_FB" or "NONE")))))
        return ok, string.format(
            "rangeLong path=%s pos=%.2f edge<=%.2f=%s soft<=%.2f=%s dist=%.2f RSI=%.0f bull=%s rej=%s | EDGE=%s DEEP=%s VWAP=%s REJECT=%s FADE=%s FB=%s",
            path, pos, edgeFrac, yn(atEdge), soft, yn(nearEdge), dist, rsi, yn(bull), yn(rejectBull),
            yn(pathEdge), yn(pathDeep), yn(pathVwap), yn(pathReject), yn(fadeOK), yn(fbOK))
    end

    local atEdge = pos >= 1.0 - edgeFrac
    local nearEdge = pos >= 1.0 - soft
    local notLower = pos >= 0.50
    local pathEdge = atEdge and dist >= 0.30 and rsi >= 52 and (bear or rejectBear)
    local pathDeep = pos >= 1.0 - edgeFrac * 0.85 and dist >= 0.20 and bear and rsi >= 48
    local pathVwap = notLower and dist >= 0.70 and rsi >= 58 and (bear or rejectBear)
    local pathReject = atEdge and rejectBear and dist >= -0.05 and rsi >= 50
    local fadeOK, fadeText = false, "fade off"
    if Cfg.UseVWAPFade then
        fadeOK, fadeText = vwapFadeStatus("S")
        if fadeOK and not notLower then
            fadeOK = false
            fadeText = "VWAP_FADE_SHORT blocked: lower half of range"
        end
    end
    local fbOK, fbText = KeyLevels.falseBreakoutStatus("S")
    local ok = pathEdge or pathDeep or pathVwap or pathReject or fadeOK or fbOK
    local path = pathEdge and "EDGE" or (pathDeep and "DEEP" or (pathVwap and "VWAP"
        or (pathReject and "REJECT" or (fadeOK and "FADE" or (fbOK and "KEY_FB" or "NONE")))))
    return ok, string.format(
        "rangeShort path=%s pos=%.2f edge>=%.2f=%s soft>=%.2f=%s dist=%.2f RSI=%.0f bear=%s rej=%s | EDGE=%s DEEP=%s VWAP=%s REJECT=%s FADE=%s FB=%s",
        path, pos, 1.0 - edgeFrac, yn(atEdge), 1.0 - soft, yn(nearEdge), dist, rsi, yn(bear), yn(rejectBear),
        yn(pathEdge), yn(pathDeep), yn(pathVwap), yn(pathReject), yn(fadeOK), yn(fbOK))
end

local function entryStructureStatus(side, regime)
    local c = Context
    if side == "B" then
        if regime == "TRENDING_UP" then
            if Cfg.TrendEntryMode == "FAST_MA_PULLBACK" then
                local pullbackOK, pullbackText = fastMAPullbackStatus(side)
                if pullbackOK then return true, pullbackText end
                local earlyOK, earlyText = earlyTrendBreakoutStatus(side)
                return earlyOK, pullbackText .. " OR " .. earlyText
            end
            local nearFast = abs(c.close - c.emaFast) <= 0.6 * c.atr
            local nearVWAP = abs(c.close - c.vwap) <= 0.6 * c.atr
            local continuation = c.momentumATR > 0.5 and c.close > c.open
                and c.vwapDistATR <= Cfg.TrendMaxExtensionATR
            return ((nearFast or nearVWAP or continuation) and c.vwapDistATR <= Cfg.TrendMaxExtensionATR),
                   string.format("trendLong(nearFast=%s nearVWAP=%s continuation=%s extension<=%.2f=%s)", yn(nearFast), yn(nearVWAP), yn(continuation), Cfg.TrendMaxExtensionATR, yn(c.vwapDistATR <= Cfg.TrendMaxExtensionATR))
        elseif regime == "CHOPPY_RANGE" then
            return rangeGeometryStatus("B")
        elseif regime == "BREAKOUT_UP" then
            local standardOK = c.consolidationOK and c.breakHigh and c.momentumATR > 0.5
                and c.vwapDistATR <= Cfg.BreakoutMaxExtensionATR
            local standardText = string.format("breakoutUp(compression=%s breakHigh=%s momentum>.5=%s extension<=%.2f=%s)", yn(c.consolidationOK), yn(c.breakHigh), yn(c.momentumATR > 0.5), Cfg.BreakoutMaxExtensionATR, yn(c.vwapDistATR <= Cfg.BreakoutMaxExtensionATR))
            if standardOK then return true, standardText end
            local keyOK, keyText = KeyLevels.breakoutStatus("B")
            if keyOK then return true, standardText .. " OR " .. keyText end
            local earlyOK, earlyText = earlyTrendBreakoutStatus(side)
            return earlyOK, standardText .. " OR " .. tostring(keyText) .. " OR " .. earlyText
        elseif regime == "REVERSAL_BULL" then
            local fadeOK, fadeText = vwapFadeStatus("B")
            if fadeOK then return true, fadeText end
            local _, _, _, reversalAllowed = tradeTypesEffective()
            if not reversalAllowed then
                return false, "generic reversal disabled; " .. tostring(fadeText)
            end
            local fbOK, fbText = KeyLevels.falseBreakoutStatus("B")
            if fbOK then return true, fbText end
            local dist = tonumber(c.vwapDistATR) or 0
            local stretchOK = dist <= -(Cfg.VWAPFadeMinATR or 2.0) * 0.75
            local legacyOK = stretchOK and c.rejectionBull and c.rsi <= 40
            return legacyOK, string.format(
                "reversalBull(stretch=%s rejection=%s RSI<=40=%s) OR %s OR %s",
                yn(stretchOK), yn(c.rejectionBull), yn(c.rsi <= 40), tostring(fadeText), tostring(fbText))
        end
    else
        if regime == "TRENDING_DOWN" then
            if Cfg.TrendEntryMode == "FAST_MA_PULLBACK" then
                local pullbackOK, pullbackText = fastMAPullbackStatus(side)
                if pullbackOK then return true, pullbackText end
                local earlyOK, earlyText = earlyTrendBreakoutStatus(side)
                return earlyOK, pullbackText .. " OR " .. earlyText
            end
            local nearFast = abs(c.close - c.emaFast) <= 0.6 * c.atr
            local nearVWAP = abs(c.close - c.vwap) <= 0.6 * c.atr
            local continuation = c.momentumATR < -0.5 and c.close < c.open
                and c.vwapDistATR >= -Cfg.TrendMaxExtensionATR
            return ((nearFast or nearVWAP or continuation) and c.vwapDistATR >= -Cfg.TrendMaxExtensionATR),
                   string.format("trendShort(nearFast=%s nearVWAP=%s continuation=%s extension>=-%.2f=%s)", yn(nearFast), yn(nearVWAP), yn(continuation), Cfg.TrendMaxExtensionATR, yn(c.vwapDistATR >= -Cfg.TrendMaxExtensionATR))
        elseif regime == "CHOPPY_RANGE" then
            return rangeGeometryStatus("S")
        elseif regime == "BREAKOUT_DOWN" then
            local standardOK = c.consolidationOK and c.breakLow and c.momentumATR < -0.5
                and c.vwapDistATR >= -Cfg.BreakoutMaxExtensionATR
            local standardText = string.format("breakoutDown(compression=%s breakLow=%s momentum<-.5=%s extension>=-%.2f=%s)", yn(c.consolidationOK), yn(c.breakLow), yn(c.momentumATR < -0.5), Cfg.BreakoutMaxExtensionATR, yn(c.vwapDistATR >= -Cfg.BreakoutMaxExtensionATR))
            if standardOK then return true, standardText end
            local keyOK, keyText = KeyLevels.breakoutStatus("S")
            if keyOK then return true, standardText .. " OR " .. keyText end
            local earlyOK, earlyText = earlyTrendBreakoutStatus(side)
            return earlyOK, standardText .. " OR " .. tostring(keyText) .. " OR " .. earlyText
        elseif regime == "REVERSAL_BEAR" then
            local fadeOK, fadeText = vwapFadeStatus("S")
            if fadeOK then return true, fadeText end
            local _, _, _, reversalAllowed = tradeTypesEffective()
            if not reversalAllowed then
                return false, "generic reversal disabled; " .. tostring(fadeText)
            end
            local fbOK, fbText = KeyLevels.falseBreakoutStatus("S")
            if fbOK then return true, fbText end
            local dist = tonumber(c.vwapDistATR) or 0
            local stretchOK = dist >= (Cfg.VWAPFadeMinATR or 2.0) * 0.75
            local legacyOK = stretchOK and c.rejectionBear and c.rsi >= 60
            return legacyOK, string.format(
                "reversalBear(stretch=%s rejection=%s RSI>=60=%s) OR %s OR %s",
                yn(stretchOK), yn(c.rejectionBear), yn(c.rsi >= 60), tostring(fadeText), tostring(fbText))
        end
    end
    return false, "regime not enabled for this side"
end

-- LOW_VOLATILITY remains a defensive no-trade state, but it must not erase a
-- higher-scoring trend whose complete existing entry structure is already
-- valid. This resolver changes only regime selection. Every normal entry gate
-- (session, spread, risk, capacity, score, setup reuse and ML) still runs later.
local function resolveLowVolatilityTrendException(regime)
    Rt.lowVolatilityDetected = regime == "LOW_VOLATILITY"
    Rt.lowVolatilityScore = Scores.lowVol or 0
    Rt.lowVolatilityDecision = Rt.lowVolatilityDetected and "LOW_VOL_BLOCKED" or "NOT_DETECTED"
    Rt.lowVolatilityCandidate = "NONE"
    Rt.lowVolatilityReason = Rt.lowVolatilityDetected and "no qualified higher-scoring trend" or "none"
    if not Rt.lowVolatilityDetected then return regime end

    -- Re-run the unchanged candidate race with only the priority low-volatility
    -- override suppressed. This avoids duplicating the regime-score and margin
    -- rules and restores their true best/second diagnostic ordering if accepted.
    local lowVolScore = Scores.lowVol
    Scores.lowVol = 0
    local candidate = detectMarketRegime()
    Scores.lowVol = lowVolScore
    Rt.lowVolatilityCandidate = candidate

    local side = candidate == "TRENDING_UP" and "B"
        or (candidate == "TRENDING_DOWN" and "S" or nil)
    if side == nil then
        Rt.lowVolatilityReason = "directional winner is not a trend"
    else
        local trendScore = side == "B" and Scores.trendUp or Scores.trendDown
        if trendScore <= lowVolScore then
            Rt.lowVolatilityReason = string.format("trend score %.1f not above LowVol %.1f", trendScore, lowVolScore)
        else
            local htf = htfDiagnostic(side)
            local htfBlocked = string.sub(htf, 1, 5) == "STALE"
                or string.sub(htf, 1, 7) == "NO_DATA"
                or string.sub(htf, 1, 7) == "OPPOSED"
                or htf == "NEUTRAL_BLOCKED"
            local dmiRatio = side == "B"
                and safeDiv(Context.plusDirection, max(Context.minusDirection, 0.1), 0)
                or safeDiv(Context.minusDirection, max(Context.plusDirection, 0.1), 0)
            local dmiOK = dmiRatio >= Cfg.EarlyBreakoutMinDMIRatio
            local adxOK = Context.adx >= 20
            local maAligned = side == "B"
                and Context.emaFast > Context.emaMed and Context.emaMed > Context.emaSlow
                or side == "S"
                    and Context.emaFast < Context.emaMed and Context.emaMed < Context.emaSlow
            local opposingBias = side == "B" and Context.marketStructureBias == "BEARISH"
                or side == "S" and Context.marketStructureBias == "BULLISH"
            local opposingCHOCH = Context.marketStructureCHOCH
                and ((side == "B" and Context.marketStructureCHOCHDirection == "DOWN")
                    or (side == "S" and Context.marketStructureCHOCHDirection == "UP"))
            local structureOK, structureText = entryStructureStatus(side, candidate)

            if htfBlocked then
                Rt.lowVolatilityReason = "HTF=" .. tostring(htf)
            elseif not adxOK then
                Rt.lowVolatilityReason = string.format("ADX %.1f below 20.0", Context.adx)
            elseif not dmiOK then
                Rt.lowVolatilityReason = string.format("DMI ratio %.2f below %.2f", dmiRatio, Cfg.EarlyBreakoutMinDMIRatio)
            elseif not maAligned then
                Rt.lowVolatilityReason = "full EMA alignment failed"
            elseif opposingBias or opposingCHOCH then
                Rt.lowVolatilityReason = "market structure opposes trend"
            elseif not structureOK then
                Rt.lowVolatilityReason = "entry structure failed: " .. tostring(structureText)
            else
                Rt.lowVolatilityDecision = "TREND_ACCEPTED"
                Rt.lowVolatilityReason = string.format(
                    "%s %.1f > LowVol %.1f; HTF=%s; ADX=%.1f; DMI=%.2f; structure passed",
                    candidate, trendScore, lowVolScore, htf, Context.adx, dmiRatio)
                return candidate
            end
        end
    end

    -- The strict exception failed. Restore the normal LOW_VOLATILITY state and
    -- its ordered priority-state diagnostics before downstream gates execute.
    return detectMarketRegime()
end

-- Execution geometry: probability score is not enough — price must still be a
-- valid place to enter. FAST_MA_PULLBACK must not authorize buy-high / sell-low
-- chases off a stale MA touch.
local function probabilityEntryGeometryStatus(side, regime, touch)
    touch = touch or probabilityFastMATouchEvidence(side)
    if Cfg.OnlyEMAPullbacks
        and regime ~= "TRENDING_UP" and regime ~= "TRENDING_DOWN" then
        return false, "EMA_PULLBACK_ONLY", "only trend EMA pullback setups are enabled"
    end
    if regime == "TRENDING_UP" or regime == "TRENDING_DOWN" then
        if Cfg.OnlyEMAPullbacks then
            local pullbackOK, pullbackText = fastMAPullbackStatus(side)
            if pullbackOK then
                local gap = touch ~= nil and touch.closeGapATR or 0
                local maxGap = min(Cfg.ProbabilityPullbackMaxEntryGapATR or 0.75,
                    Cfg.TrendPullbackMaxCloseATR or 0.75)
                if gap <= maxGap then
                    return true, "FAST_MA_PULLBACK", "EMA pullback VALID " .. tostring(pullbackText)
                end
                return false, "FAST_MA_PULLBACK", string.format(
                    "EMA pullback gap %.2f > max %.2f ATR", gap, maxGap)
            end
            return false, "FAST_MA_PULLBACK", "EMA pullback INVALID: " .. tostring(pullbackText)
        end
        if Cfg.TrendEntryMode ~= "FAST_MA_PULLBACK" then
            local structureOK, structureText = entryStructureStatus(side, regime)
            return structureOK, "LEGACY_CONTINUATION",
                "legacy trend geometry " .. (structureOK and "VALID: " or "INVALID: ")
                    .. tostring(structureText)
        end

        -- Primary gate: full pullback quality (fresh touch, reclaim, tight gap,
        -- not extended). Same rules as entryStructureStatus for consistency.
        local pullbackOK, pullbackText = fastMAPullbackStatus(side)
        if pullbackOK then
            local gap = touch ~= nil and touch.closeGapATR or 0
            local maxGap = min(Cfg.ProbabilityPullbackMaxEntryGapATR or 0.75,
                Cfg.TrendPullbackMaxCloseATR or 0.75)
            if gap <= maxGap then
                return true, "FAST_MA_PULLBACK",
                    "pullback VALID " .. tostring(pullbackText)
            end
            return false, "FAST_MA_PULLBACK", string.format(
                "pullback shape OK but gap %.2f > max %.2f ATR (no chase)",
                gap, maxGap)
        end

        -- Early breakout is a separate path and must also reject extended entries.
        local breakoutOK, breakoutText = earlyTrendBreakoutStatus(side)
        if breakoutOK then
            local c = Context
            local gap = safeDiv(abs(c.close - c.emaFast), c.atr, math.huge)
            local maxBreakGap = Cfg.EarlyBreakoutMaxFastMAGapATR or 1.50
            local vwapCap = Cfg.EarlyBreakoutMaxVWAPExtensionATR or 3.50
            local extended = side == "B"
                and ((c.vwapDistATR or 0) > vwapCap or gap > maxBreakGap)
                or side == "S"
                    and ((c.vwapDistATR or 0) < -vwapCap or gap > maxBreakGap)
            if not extended then
                return true, "BREAKOUT_CONTINUATION",
                    "pullback not armed; breakout valid: " .. breakoutText
            end
            return false, "BREAKOUT_CONTINUATION",
                "breakout rejected: extended (buy-high/sell-low protection) | " .. breakoutText
        end

        return false, "FAST_MA_PULLBACK",
            "pullback INVALID: " .. tostring(pullbackText)
    end

    -- VWAP fade geometry (mean-reversion from extreme stretch).
    if Cfg.UseVWAPFade and (regime == "REVERSAL_BULL" or regime == "REVERSAL_BEAR") then
        local fadeOK, fadeText = vwapFadeStatus(side)
        if fadeOK then
            return true, "VWAP_FADE", "VWAP fade VALID: " .. tostring(fadeText)
        end
    end

    -- Probability may rank a non-trend candidate, but it cannot bypass that
    -- regime's existing location/trigger geometry. This is especially
    -- important for range trades, whose VWAP mean target must still be ahead
    -- of the entry rather than already reached.
    local structureOK, structureText = entryStructureStatus(side, regime)
    local entryType = string.sub(regime,1,8) == "BREAKOUT" and "BREAKOUT" or tostring(regime)
    return structureOK, entryType,
        "regime-specific geometry " .. (structureOK and "VALID: " or "INVALID: ")
            .. tostring(structureText)
end

local function buildSetupIdentity(side, regime, geometryOK, entryType)
    local anchor
    local earlyBreakout = false
    -- Match the same precedence used by entryStructureStatus(): a valid
    -- FAST_MA_PULLBACK is a pullback setup even when breakout conditions also
    -- happen to be true. The early-breakout anchor is selected only when the
    -- pullback path failed and that fallback path actually admitted the trade.
    if Cfg.TrendEntryMode == "FAST_MA_PULLBACK"
        and (regime == "TRENDING_UP" or regime == "TRENDING_DOWN") then
        if geometryOK == nil then
            geometryOK, entryType = probabilityEntryGeometryStatus(side, regime)
        end
        earlyBreakout = geometryOK and entryType == "BREAKOUT_CONTINUATION"
    end
    if earlyBreakout and side == "B" then anchor = Context.swingHigh
    elseif earlyBreakout and side == "S" then anchor = Context.swingLow
    elseif regime == "BREAKOUT_UP" then anchor = Context.swingHigh
    elseif regime == "BREAKOUT_DOWN" then anchor = Context.swingLow
    elseif side == "B" then anchor = Context.swingLow
    else anchor = Context.swingHigh end
    if not validNumber(anchor) then anchor = Context.vwap end
    if not validNumber(anchor) then return nil, nil end
    if geometryOK and entryType == "FAST_MA_PULLBACK" then
        local touch = probabilityFastMATouchEvidence(side)
        if not validNumber(touch.touchDate) then return nil, nil end
        return tostring(regime) .. ":" .. side .. ":PB:" .. string.format("%.10f", touch.touchDate), anchor
    end
    return tostring(regime) .. ":" .. tostring(side) .. ":" .. string.format("%.10f", anchor), anchor
end

local function displaySetupKey(key)
    if key == nil then return "NA" end
    local text = tostring(key)
    local prefix, numberText = string.match(text, "^(.*:)([%-]?%d+%.%d+)$")
    local number = tonumber(numberText)
    if prefix ~= nil and number ~= nil then return prefix .. string.format("%.2f", number) end
    return text
end

local function pruneUsedSetupKeys(p)
    local changed = false
    for key, usedPeriod in pairs(Rt.usedSetupKeys) do
        local expiry = Cfg.SetupResetBars
        if string.find(tostring(key), ":PB:", 1, true) then
            expiry = max(expiry, max((Cfg.PullbackMaxAgeBars or 5)+1,
                (Cfg.CleanPullbackRetestLookbackBars or 0)+1))
        end
        if usedPeriod == nil or p - usedPeriod >= expiry then
            Rt.usedSetupKeys[key] = nil
            changed = true
        end
    end
    if changed then persistEntryRuntimeState() end
end

local function collectEntryDiagnostics(side, regime)
    local blockers, passed = {}, {}
    local function add(list, value) list[#list + 1] = value end

    -- Hard gates: permission, enabled trade type, directional quality, capacity,
    -- broker/account safety, data integrity, setup reuse, regime-specific
    -- execution geometry, and the final probability threshold. HTF opposition,
    -- candle color and regime margin remain evidence; trend-pullback reclaim is
    -- directional geometry.
    if side == "B" and Cfg.AllowedSide == "Sell" then add(blockers, "BUY side disabled")
    elseif side == "S" and Cfg.AllowedSide == "Buy" then add(blockers, "SELL side disabled")
    else add(passed, "side enabled") end

    local policyBlockers, policyPassed = Rt.directionalPolicyStatus(side, regime)
    for _, text in ipairs(policyBlockers) do add(blockers, text) end
    for _, text in ipairs(policyPassed) do add(passed, text) end

    if Cfg.OneTradePerDirection and ownTradesCount(side) >= 1 then
        add(blockers, side == "B" and "one-long limit" or "one-short limit")
    else add(passed, "direction capacity") end

    local netConflict, netReason = entryPositionConflict(side)
    if netConflict then add(blockers, "account-position conflict: " .. tostring(netReason))
    elseif Cfg.AllowTrade and not Rt.HedgingEnabled then add(passed, "no opposite position to net") end

    local htf = htfDiagnostic(side)
    local htfDataBad = string.sub(htf,1,5) == "STALE" or string.sub(htf,1,7) == "NO_DATA"
    local htfOpposed = htf == "OPPOSED_BEARISH" or htf == "OPPOSED_BULLISH"
    if Cfg.UseHTF and Cfg.ProbabilityRequireHTFData and htfDataBad then
        add(blockers, "HTF data integrity=" .. htf)
    elseif Cfg.UseHTF and htf == "NEUTRAL_BLOCKED" then
        add(blockers, "HTF neutral entries disabled")
    elseif Cfg.UseHTF and htfOpposed and Cfg.HTFOppositionMode == "BLOCK" then
        add(blockers, "HTF confirmed opposition blocked (mode=BLOCK): " .. htf)
    else
        add(passed, "HTF evidence=" .. htf
            .. (Cfg.UseHTF and (" mode=" .. tostring(Cfg.HTFOppositionMode or "EVIDENCE")) or ""))
    end

    if Cfg.OpposingCHOCHHardBlock and Context.marketStructureCHOCH then
        local opposingCHOCH = (side == "B" and Context.marketStructureCHOCHDirection == "DOWN")
            or (side == "S" and Context.marketStructureCHOCHDirection == "UP")
        if opposingCHOCH then
            add(blockers, string.format("opposing CHOCH hard block: %s",
                tostring(Context.marketStructureCHOCHDirection)))
        else
            add(passed, "CHOCH not opposing candidate")
        end
    elseif Cfg.OpposingCHOCHHardBlock then
        add(passed, "no CHOCH hard-block trigger")
    end

    if not validNumber(Context.rangeATR) or Context.rangeATR > Cfg.LargeCandleATR then
        add(blockers, string.format("signal candle %.2fATR > %.2fATR maximum",
            tonumber(Context.rangeATR) or math.huge, Cfg.LargeCandleATR))
    else
        add(passed, string.format("signal candle %.2f/%.2fATR", Context.rangeATR, Cfg.LargeCandleATR))
    end

    if Cfg.UseVolumeFilter and not Context.volumeOK then
        add(blockers, "tick-volume too low: " .. tostring(Context.volumeStatus or "failed"))
    elseif Cfg.UseVolumeFilter then
        add(passed, "tick-volume " .. tostring(Context.volumeStatus or "ok"))
    end

    local parts, score, touch = probabilityScoreBreakdown(side, regime)
    local required, reqNote = smartRequiredScore(side, regime, htf, parts)
    if score < required then
        add(blockers, string.format("probability evidence %.1f < %.1f (%s)", score, required, reqNote))
    else
        add(passed, string.format("probability evidence %.1f >= %.1f (%s)", score, required, reqNote))
    end
    if Cfg.UseSmartEvidence and parts.smartDelta ~= nil and parts.smartDelta ~= 0 then
        add(passed, string.format("smartDelta=%+.1f [%s]", parts.smartDelta, tostring(parts.smartNote or "")))
    end

    local coherenceOK, coherenceText = evidenceCoherenceStatus(side, regime, parts)
    if coherenceOK then add(passed, coherenceText)
    else add(blockers, coherenceText) end

    local structureText = string.format("bias=%s sequence=%s BOS=%s CHOCH=%s",
        tostring(Context.marketStructureBias or "UNKNOWN"), tostring(Context.marketStructureSequence or "NA"),
        side == "B" and yn(Context.marketStructureBOSUp) or yn(Context.marketStructureBOSDown),
        yn(Context.marketStructureCHOCH))
    add(passed, string.format("EMA%d touch=%s age=%s reclaim=%s candle=%s gap=%.2fATR",
        Cfg.FastPeriod, yn(touch.retested), touch.retested and tostring(touch.retestAge) or "NA",
        yn(touch.reclaimed), yn(touch.candle), touch.closeGapATR))

    local geometryOK, entryType, geometryText = probabilityEntryGeometryStatus(side, regime, touch)
    if geometryOK then
        add(passed, "entry geometry " .. tostring(entryType) .. ": " .. tostring(geometryText))
    else
        add(blockers, "entry geometry " .. tostring(entryType) .. ": " .. tostring(geometryText))
    end

    local setupKey, setupAnchor = buildSetupIdentity(side, regime, geometryOK, entryType)
    local globalSetupKey = Rt.globalSetupFingerprint(side, regime, entryType, setupAnchor)
    if setupKey == nil then add(blockers, "setup identity unavailable")
    elseif Rt.usedSetupKeys[setupKey] ~= nil then add(blockers, "setup already traded: " .. displaySetupKey(setupKey))
    elseif globalSetupKey ~= nil and Rt.usedSetupKeys[globalSetupKey] ~= nil then
        add(blockers, "setup already traded by another entry engine: " .. displaySetupKey(globalSetupKey))
    else add(passed, "new setup: " .. displaySetupKey(setupKey)) end

    return blockers, passed, parts, score, required, htf, structureText, setupKey, setupAnchor, entryType, geometryText, globalSetupKey
end

local function formatList(list)
    if list == nil or #list == 0 then return "none" end
    return table.concat(list, "; ")
end

-- APS-style trailing-stop diagnostic. The value reported as stop= is the
-- strategy's internal ATR/break-even thesis stop used by manageOpenPositions().
-- BrokerRatchet reports whether real stop edits are enabled. Each trade shows
-- both the computed thesis level and the last broker stop confirmed/submitted.
local function trailingDiagnostic(p)
    local info = {
        brokerTrail = Cfg.TrailingStop and true or false,
        entries = {}, blockedExits = {}, tradeCount = 0
    }
    if not Cfg.AllowTrade or not checkReady("trades") then return info end
    local trades = core.host:findTable("trades")
    if trades == nil then return info end
    local enum = trades:enumerator()
    local row = enum:next()
    while row ~= nil do
        if row.AccountID == Rt.Account and row.OfferID == Rt.Offer and row.QTXT == Cfg.CustomID then
            info.tradeCount = info.tradeCount + 1
            -- Read the ratchet manageOpenPositions() already advanced this bar
            -- rather than recomputing it a second time from the same inputs.
            local stop = Rt.trailStops[row.TradeID]
            local brokerStop = Rt.brokerStopRates[row.TradeID]
            if not validNumber(brokerStop) then
                local tableStop = tonumber(row.Stop)
                if validNumber(tableStop) and tableStop > 0 then brokerStop = tableStop end
            end
            local atr = Ind.atr[p]
            local px = executableExitPrice(row.BS, p)
            local stopDistATR = nil
            if stop ~= nil and atr ~= nil and atr > 0 and px ~= nil then
                stopDistATR = math.abs(px - stop) / atr
            end
            local openRate = tonumber(row.Open)
            local breakEven = false
            if validNumber(openRate) and stop ~= nil then
                if row.BS == "B" then
                    breakEven = stop >= openRate
                else
                    breakEven = stop <= openRate
                end
            end
            local entry = "id=" .. tostring(row.TradeID) .. ":" .. tostring(row.BS)
            if stop ~= nil then
                entry = entry .. "@" .. string.format("%.5f", stop)
                if stopDistATR ~= nil then entry = entry .. "/" .. string.format("%.2fATR", stopDistATR) end
                entry = entry .. "/BE=" .. yn(breakEven)
            elseif Rt.tradeRiskUnavailable[row.TradeID] then
                entry = entry .. "@RISK_UNAVAILABLE"
            else
                entry = entry .. "@NA"
            end
            if validNumber(brokerStop) and brokerStop > 0 then
                entry = entry .. "/broker=" .. string.format("%.5f", brokerStop)
            elseif Cfg.TrailingStop then
                entry = entry .. "/broker=UNRESOLVED"
            end
            if Rt.pendingStopEdits[row.TradeID] ~= nil then entry = entry .. "/EDIT_PENDING" end
            info.entries[#info.entries + 1] = entry

            local blocked = Rt.blockedExits[row.TradeID]
            if blocked ~= nil then
                info.blockedExits[#info.blockedExits + 1] = "id=" .. tostring(row.TradeID)
                    .. ":reason=" .. tostring(blocked.reason)
                    .. ":sinceBar=" .. tostring(blocked.sinceBar)
            end
        end
        row = enum:next()
    end
    return info
end

-- Emit ONE readable multi-line terminal message per closed bar.
-- Top card = trading decision in plain language; below = detail for analysis.
-- Diagnostic helpers are nested here so they do not consume main-chunk locals
-- (Lua 5.1 / Indicore hard limit: 200 locals in the main function).
-- Market Outlook v1: descriptive closed-bar state + next 3-bar evidence.
-- Independent of entry qualification and ML win probability. These bounded
-- heuristic scores are NOT calibrated probabilities and need forward testing.
-- A mixed tape is UNCERTAIN, not automatically SIDEWAYS. No future bars used.
-- Attached to the existing helper table to preserve Lua 5.1 local limits.
function SmartAI.marketOutlook(c, st)
    local required = {"close", "open", "high", "low", "atr", "emaFast", "emaMed",
        "emaSlow", "emaFastSlope", "momentumATR", "adx", "plusDirection",
        "minusDirection", "efficiency", "vwapDistATR"}
    for i = 1, #required do
        if not validNumber(c[required[i]]) then
            return {now="UNAVAILABLE", likely="UNCERTAIN", confidence="LOW",
                note="missing/invalid " .. required[i]}
        end
    end
    if c.atr <= 0 or c.high < c.low then
        return {now="UNAVAILABLE", likely="UNCERTAIN", confidence="LOW", note="invalid ATR/OHLC"}
    end
    local atr = c.atr
    local slope = clamp(c.emaFastSlope / atr, -1, 1)
    local momentum = clamp(c.momentumATR / 2, -1, 1)
    local stack = 0
    if c.emaFast > c.emaMed and c.emaMed > c.emaSlow then stack = 1
    elseif c.emaFast < c.emaMed and c.emaMed < c.emaSlow then stack = -1 end
    local di = clamp(safeDiv(c.plusDirection - c.minusDirection,
        c.plusDirection + c.minusDirection, 0) * 3, -1, 1)
    local efficiency = clamp(c.efficiency, 0, 1)
    local structure = 0
    if not st.stale then
        if st.bias == "BULLISH" then structure = 1
        elseif st.bias == "BEARISH" then structure = -1 end
        structure = structure * clamp((tonumber(st.confidence) or 0) / 100, 0, 1)
    end
    local candle = clamp(safeDiv(c.close - c.open, c.high - c.low, 0), -1, 1)
    local vwap = clamp(c.vwapDistATR, -1, 1)
    local votes = {stack * 22, slope * 18, momentum * 18, di * 14,
        structure * 14, vwap * 8, candle * 6}
    local bull, bear = 0, 0
    for i = 1, #votes do
        if votes[i] >= 0 then bull = bull + votes[i] else bear = bear - votes[i] end
    end
    local conflict = min(bull, bear)
    local direction = bull - bear
    -- Sideways requires positive evidence of inefficient, flat, weak movement.
    local sideways = 35 * (1 - efficiency)
        + 25 * (1 - clamp(c.adx / 30, 0, 1))
        + 20 * (1 - abs(slope)) + 20 * (1 - abs(momentum))
    local breakout = (c.breakHigh and direction > 15) or (c.breakLow and direction < -15)
    if breakout then sideways = sideways * 0.55 end
    local up = clamp(bull - bear * 0.35, 0, 100)
    local down = clamp(bear - bull * 0.35, 0, 100)
    sideways = clamp(sideways, 0, 100)
    local now = "MIXED / TRANSITION"
    if c.breakHigh and direction > 15 then now = "BREAKING UP"
    elseif c.breakLow and direction < -15 then now = "BREAKING DOWN"
    elseif stack > 0 and slope > 0.08 and momentum > 0.05 then now = "TRENDING UP"
    elseif stack < 0 and slope < -0.08 and momentum < -0.05 then now = "TRENDING DOWN"
    elseif stack > 0 and momentum < -0.05 then now = "PULLBACK IN UPTREND"
    elseif stack < 0 and momentum > 0.05 then now = "BOUNCE IN DOWNTREND"
    elseif sideways >= 60 and abs(direction) < 25 then now = "SIDEWAYS / CONSOLIDATING" end
    local likely, best, runner = "SIDEWAYS", sideways, max(up, down)
    if up > best then likely, best, runner = "UP", up, max(sideways, down) end
    if down > best then likely, best, runner = "DOWN", down, max(sideways, up) end
    local margin = best - runner
    local confidence = "LOW"
    if best < 50 or margin < 12 or conflict >= 22 then likely = "UNCERTAIN"
    elseif best >= 70 and margin >= 25 and conflict < 10 then confidence = "HIGH"
    else confidence = "MODERATE" end
    local note = string.format("EMA=%s slope=%+.2fATR momentum=%+.2fATR ADX=%.1f efficiency=%.2f structure=%s conflict=%.1f",
        stack > 0 and "bull" or (stack < 0 and "bear" or "mixed"),
        slope, c.momentumATR, c.adx, efficiency, st.stale and "stale" or tostring(st.bias or "unknown"), conflict)
    return {now=now, likely=likely, confidence=confidence, up=up, down=down,
        sideways=sideways, margin=margin, note=note}
end

function SmartAI.updateMarketOutlook(p)
    local outlook = SmartAI.marketOutlook(Context, Rt.marketStructure or {})
    outlook.period = p
    outlook.asOf = csvTimestampUTC(closedBarEndDate(p) or Rt.Source:date(p))
    Rt.marketOutlook = outlook
    return outlook
end

function SmartAI.marketOutlookText()
    local o = Rt.marketOutlook
    if o == nil then return "MARKET NOW | UNAVAILABLE - waiting for a complete closed candle" end
    local head = "MARKET NOW | " .. o.now .. " | as of " .. tostring(o.asOf or "") .. " UTC (closed candle)"
    if o.up == nil then return head .. "\nOUTLOOK | UNCERTAIN | " .. o.note end
    return head .. string.format("\nOUTLOOK | next 3 bars: %s | confidence=%s | evidence /100: UP %.0f DOWN %.0f SIDEWAYS %.0f | not probabilities",
        o.likely, o.confidence, o.up, o.down, o.sideways)
        .. "\nWHY | " .. o.note
        .. "\nRECHECK | outlook expires next closed candle; opposite momentum or a range break can change the bias"
end

-- Compact commentary: deterministic explanation of actual decisions.
-- Diagnostic only: does not alter state, scores, orders or risk permissions.
function SmartAI.shortDecision(decision, globalBlockers, longInfo, shortInfo, p)
    local l, r = tonumber(longInfo.score) or 0, tonumber(shortInfo.score) or 0
    local side = l >= r and "B" or "S"
    if decision == "BUY" then side="B" elseif decision == "SELL" then side="S" end
    local focus = side=="B" and longInfo or shortInfo
    local action = decision=="BUY" or decision=="SELL"
    local reasons, seen = {}, {}
    local function add(raw)
        raw = tostring(raw or "")
        if raw=="" or raw=="none" or seen[raw] then return end
        seen[raw]=true
        local lower = string.lower(raw)
        local text, nextStep, priority = raw, "Wait for all entry checks to pass on a completed candle.", 50
        if string.find(lower,"loss",1,true) or string.find(lower,"equity",1,true) then
            text="Risk limit or account-equity check blocks new entries."
            nextStep="Risk controls must clear before any new entry.";priority=1
        elseif string.find(lower,"mandatory close",1,true) then
            text="Mandatory-close window: new entries disabled."
            nextStep="Wait until the configured entry window permits trading.";priority=2
        elseif string.find(lower,"outside session",1,true) or string.find(lower,"global session disabled",1,true) then
            text="Outside the configured trading session."
            nextStep="Wait for an enabled session, then reassess a fresh setup.";priority=4
        elseif string.find(lower,"news",1,true) then
            text="News filter blocks new entries."
            nextStep="Wait for the news filter to clear.";priority=3
        elseif string.find(lower,"lunch",1,true) then
            text="Configured lunch pause is active."
            nextStep="Wait for the configured pause to end.";priority=4
        elseif string.find(lower,"spread",1,true) or string.find(lower,"execution quality",1,true) then
            text="Spread or quote-quality limits block entry."
            nextStep="Wait for valid quotes and acceptable execution costs.";priority=5
        elseif string.find(lower,"not ready",1,true) or string.find(lower,"data integrity",1,true) then
            text="Required trading data is not ready."
            nextStep="Wait for complete, current data.";priority=2
        elseif string.find(lower,"cooldown",1,true) then
            text="Trade cooldown is active.";nextStep="Wait for cooldown to finish, then reassess.";priority=8
        elseif string.find(lower,"position",1,true) or string.find(lower,"one-long",1,true) or string.find(lower,"one-short",1,true) then
            text="Position capacity or account-position rules block entry.";priority=7
        elseif string.find(lower,"submission failed",1,true) then
            text="Order submission failed; no fill is confirmed.";nextStep="Check the broker rejection/operation log.";priority=1
        elseif string.find(lower,"geometry",1,true) then
            text="The leading setup has no valid entry location/trigger."
            nextStep="Wait for the selected setup's location and trigger to qualify.";priority=15
        elseif string.find(lower,"already traded",1,true) then
            text="This setup has already been used.";nextStep="Wait for a new eligible setup.";priority=12
        elseif string.find(lower,"smartai=",1,true) then
            text="The trained entry filter vetoed this setup.";priority=10
        elseif string.find(lower,"probability evidence",1,true) then
            text="Entry evidence is below its required threshold.";priority=20
        elseif string.find(lower,"evidence edge",1,true) or string.find(lower,"evidence tie",1,true) then
            text="Neither side has enough directional advantage.";priority=21
        elseif string.find(lower,"trade type disabled",1,true) then
            text="This trade type is disabled by the current permissions.";priority=11
        elseif string.find(lower,"dmi",1,true) then
            text="Directional movement does not confirm the selected side.";priority=16
        elseif string.find(lower,"adx",1,true) then
            text="Trend strength is below the required minimum.";priority=16
        end
        text=string.gsub(text,"[\r\n]+"," ")
        if #text>170 then text=string.sub(text,1,167).."..." end
        reasons[#reasons+1]={text=text,nextStep=nextStep,priority=priority,order=#reasons+1}
    end
    for _,v in ipairs(globalBlockers or {}) do add(v) end
    for _,v in ipairs(focus.blockers or {}) do add(v) end
    table.sort(reasons,function(a,b) return a.priority<b.priority or (a.priority==b.priority and a.order<b.order) end)
    local label="WAIT - NO NEW ENTRY"
    if action then label=decision .. (Cfg.AllowTrade and " REQUEST SUBMITTED (fill unconfirmed)" or " SIGNAL ONLY (trading disabled)") end
    local c=Context
    local structure="Mixed MA structure"
    if validNumber(c.emaFast) and validNumber(c.emaMed) and validNumber(c.emaSlow) then
        if c.emaFast>c.emaMed and c.emaMed>c.emaSlow then structure="Bullish MA structure"
        elseif c.emaFast<c.emaMed and c.emaMed<c.emaSlow then structure="Bearish MA structure" end
    end
    local pressure="mixed current pressure"
    if validNumber(c.momentumATR) and validNumber(c.plusDirection) and validNumber(c.minusDirection) then
        if c.momentumATR<0 and c.minusDirection>c.plusDirection then pressure="current pressure DOWN"
        elseif c.momentumATR>0 and c.plusDirection>c.minusDirection then pressure="current pressure UP" end
    end
    local bias=Rt.marketOutlook and Rt.marketOutlook.likely or "UNCERTAIN"

    local vwapLine = "VWAP n/a"
    do
        local vwap = tonumber(c.vwap)
        local closePx = tonumber(c.close)
        local atr = tonumber(c.atr) or 0
        local distATR = tonumber(c.vwapDistATR)
        if validNumber(vwap) and validNumber(closePx) then
            local distPts = closePx - vwap
            local sideTxt = distPts > 0.05 and "ABOVE" or (distPts < -0.05 and "BELOW" or "AT")
            local atrTxt = (validNumber(distATR) and atr > 0)
                and string.format("%.2f ATR", abs(distATR))
                or (atr > 0 and string.format("%.2f ATR", abs(distPts) / atr) or "n/a")
            vwapLine = string.format("close %.2f is %s VWAP %.2f by %.1f pts (%s)",
                closePx, sideTxt, vwap, abs(distPts), atrTxt)
        elseif validNumber(distATR) then
            local sideTxt = distATR > 0.02 and "ABOVE" or (distATR < -0.02 and "BELOW" or "AT")
            vwapLine = string.format("%s VWAP by %.2f ATR", sideTxt, abs(distATR))
        end
    end

    local lines={"ARS | " .. label .. " | " .. tostring(Cfg.ActivityEffectiveProfile or Cfg.ActivityProfile or "ACTIVE")
        .. " | " .. csvTimestampUTC(closedBarEndDate(p) or Rt.Source:date(p)) .. " UTC"}
    if action then
        lines[#lines+1]="BLOCKERS | none - entry checks passed (" .. tostring(focus.entryType or focus.regime) .. ")"
    elseif #reasons > 0 then
        local blockParts = {}
        for i = 1, min(3, #reasons) do
            blockParts[#blockParts + 1] = tostring(i) .. ") " .. reasons[i].text
        end
        lines[#lines+1]="BLOCKERS | " .. table.concat(blockParts, " | ")
        if #reasons > 3 then
            lines[#lines] = lines[#lines] .. string.format(" (+%d more)", #reasons - 3)
        end
    else
        lines[#lines+1]="BLOCKERS | none listed - see full diagnostics"
    end
    lines[#lines+1]="VWAP | " .. vwapLine
    lines[#lines+1]="MARKET | " .. structure .. "; " .. pressure .. ". Outlook: " .. tostring(bias) .. " (evidence only)."
    lines[#lines+1]="STRUCTURE | " .. Rt.structureSummary()
    lines[#lines+1]=string.format("EVIDENCE | Long %.0f/%.0f; short %.0f/%.0f; edge %.1f needs %.1f.",
        l,longInfo.required or 0,r,shortInfo.required or 0,abs(l-r),smartRequiredEdge(side,longInfo.htf,shortInfo.htf))
    local q=Rt.executionQuality
    if q and not q.ok then
        lines[#lines+1]="COST | " .. tostring(q.reason) .. (Cfg.ExecutionQualityMode=="OBSERVE" and " (observe only; not a blocker)." or " (entry filter active).")
    end
    if not action then
        lines[#lines+1]="NEXT | " .. (#reasons>0 and reasons[1].nextStep or "Reassess on the next completed candle.")
    end
    return table.concat(lines,"\n")
end

function SmartAI.decisionDetails(globalBlockers,longInfo,shortInfo)
    local function sideDetails(name,info)
        local parts=info.parts or {}
        return name .. " regime=" .. tostring(info.regime) .. " type=" .. tostring(info.entryType)
            .. " score=" .. tostring(info.score) .. " required=" .. tostring(info.required)
            .. " geometry=" .. tostring(info.geometryText)
            .. string.format(" buckets=dir:%.2f,str:%.2f,loc:%.2f,htf:%.2f,mom:%.2f,env:%.2f,smart:%.2f",
                parts.direction or 0,parts.structure or 0,parts.location or 0,parts.htf or 0,parts.momentum or 0,parts.environment or 0,parts.smartDelta or 0)
            .. " blockers=" .. table.concat(info.blockers or {}," || ")
            .. " passed=" .. table.concat(info.passed or {}," || ")
    end
    return "GLOBAL: " .. table.concat(globalBlockers or {}," || ") .. "\n"
        .. sideDetails("LONG",longInfo) .. "\n" .. sideDetails("SHORT",shortInfo)
end

local function traceFullBar(p, decision, globalBlockers, globalPassed, longInfo, shortInfo, acceptedState)
    if not Cfg.ShowDebug and not Cfg.WriteCSVLogFile then return end
    if Cfg.CompactDiagnostics ~= false then
        local brief=SmartAI.shortDecision(decision,globalBlockers,longInfo,shortInfo,p)
        if Cfg.WriteCSVLogFile then
            writeCSVLog("BAR",brief .. "\n" .. SmartAI.decisionDetails(globalBlockers,longInfo,shortInfo),closedBarEndDate(p) or Rt.Source:date(p))
        end
        if Cfg.ShowDebug then emitTerminalDiagnostic(brief) end
        return
    end

    -- Professional AI decision brief helpers (plain-English, trader-facing).
    local function diagnosticWhyText(action, blockers, focusInfo)
        if action == "BUY" or action == "SELL" then
            local entryType = tostring(focusInfo.entryType or "setup")
            return string.format(
                "Clear %s thesis in %s: evidence %.0f clears the %.0f bar, geometry %s is valid",
                action, tostring(focusInfo.regime or "regime"),
                tonumber(focusInfo.score) or 0, tonumber(focusInfo.required) or 0, entryType)
        end
        if blockers == nil or #blockers == 0 or blockers[1] == "none" then
            return "No actionable edge this bar - conditions incomplete"
        end
        local raw = tostring(blockers[1])
        if string.find(raw, "probability evidence", 1, true) then
            return "Evidence package is below the quality bar for a live entry"
        end
        if string.find(raw, "directional evidence edge", 1, true) then
            return "Long and short scores are nearly tied - no directional conviction"
        end
        if string.find(raw, "bucket mins", 1, true) then
            return "Factors disagree (direction / structure / location / momentum incomplete)"
        end
        if string.find(raw, "entry geometry", 1, true) then
            return "Thesis is interesting but price is not at a valid entry location yet"
        end
        if string.find(raw, "VWAP_FADE", 1, true) or string.find(raw, "VWAP fade", 1, true) then
            return "VWAP fade conditions incomplete (need stretch + RSI extreme + rejection)"
        end
        if string.find(raw, "not dominant", 1, true) then
            return "Selected regime is not clearly stronger than competing regimes"
        end
        if string.find(raw, "HTF", 1, true) or string.find(raw, "higher", 1, true) then
            return "Higher-timeframe context blocks or cannot confirm this side"
        end
        if string.find(raw, "spread", 1, true) then
            return "Spread is too expensive relative to expected move"
        end
        if string.find(raw, "cooldown", 1, true) then
            return "Cooldown active after the last broker-confirmed trade close"
        end
        if string.find(raw, "session", 1, true) or string.find(raw, "lunch", 1, true) then
            return "Outside the allowed session window for new risk"
        end
        if string.find(raw, "news", 1, true) then
            return "Scheduled news blackout - no new entries"
        end
        if string.find(raw, "risk", 1, true) or string.find(raw, "loss", 1, true)
            or string.find(raw, "equity", 1, true) then
            return "Risk brake engaged (daily loss, streak, or exposure cap)"
        end
        if string.find(raw, "CHOCH", 1, true) then
            return "Market structure flipped against the candidate side"
        end
        if string.find(raw, "setup already", 1, true) then
            return "This swing setup was already used - waiting for a new anchor"
        end
        if string.find(raw, "stronger market side is blocked", 1, true) then
            return "Preferred side is gated; weaker side is not substituted"
        end
        if string.find(raw, "candle", 1, true) then
            return "Signal candle is oversized vs ATR (chase / spike risk)"
        end
        if string.find(raw, "volume", 1, true) then
            return "Tick-volume confirmation failed (data present but weak)"
        end
        if string.find(raw, "position", 1, true) or string.find(raw, "one-", 1, true) then
            return "Position limits prevent adding risk"
        end
        if string.find(raw, "ADX", 1, true) then
            return "Trend strength (ADX) below the minimum for this regime"
        end
        if string.find(raw, "DMI", 1, true) then
            return "Directional movement (DI+/DI-) does not confirm the side"
        end
        return raw
    end

    local function diagnosticQualityGrade(score, required)
        local s = tonumber(score) or 0
        local r = tonumber(required) or 65
        local over = s - r
        if over >= 15 then return "A (strong)" end
        if over >= 8 then return "B (good)" end
        if over >= 0 then return "C (marginal)" end
        if over >= -8 then return "D (near miss)" end
        return "F (weak)"
    end

    local function diagnosticConfidence(action, score, required, edgeNow, edgeNeed, quality)
        if action == "BUY" or action == "SELL" then
            local over = (tonumber(score) or 0) - (tonumber(required) or 0)
            local edge = tonumber(edgeNow) or 0
            local need = math.max(tonumber(edgeNeed) or 1, 1)
            local conf = 55 + clamp(over, -10, 25) + clamp(edge / need * 10, 0, 20)
            conf = clamp(conf, 50, 95)
            if quality and string.sub(quality, 1, 1) == "A" then conf = max(conf, 80) end
            if quality and string.sub(quality, 1, 1) == "B" then conf = max(conf, 70) end
            return string.format("%.0f/100 heuristic", conf)
        end
        -- WAIT: confidence that standing aside is correct
        local s = tonumber(score) or 0
        local r = tonumber(required) or 50
        local e = tonumber(edgeNow) or 0
        local en = math.max(tonumber(edgeNeed) or 5, 1)
        if e < en * 0.5 then return "high (no edge)" end
        if s + 8 < r then return "high (weak package)" end
        if s < r then return "medium (near miss)" end
        return "medium (gated)"
    end

    local function diagnosticMarketRead(c, focusInfo, adxValue, adxState)
        local regime = tostring(focusInfo.regime or Rt.currentRegime or "UNKNOWN")
        local mom = tonumber(c.momentumATR) or 0
        local vwap = tonumber(c.vwapDistATR) or 0
        local atr = tonumber(c.atr) or 0
        local rsi = tonumber(c.rsi) or 50
        local momTxt = mom >= 0.5 and "bullish impulse"
            or (mom <= -0.5 and "bearish impulse" or "balanced tape")
        local locTxt = vwap > 1.5 and "stretched above VWAP"
            or (vwap < -1.5 and "stretched below VWAP" or "near VWAP / fair value")
        return string.format("%s | ADX %.0f (%s) | RSI %.0f | %s | %s | ATR %.1f",
            regime, tonumber(adxValue) or 0, tostring(adxState or ""),
            rsi, momTxt, locTxt, atr)
    end

    local function diagnosticVWAPLine(c)
        local vwap = tonumber(c.vwap)
        local closePx = tonumber(c.close)
        local atr = tonumber(c.atr) or 0
        local distATR = tonumber(c.vwapDistATR) or 0
        if not validNumber(vwap) then
            return "VWAP n/a"
        end
        local distPts = validNumber(closePx) and (closePx - vwap) or (distATR * atr)
        local side = distPts > 0.05 and "above" or (distPts < -0.05 and "below" or "at")
        local closeTxt = validNumber(closePx) and string.format("%.2f", closePx) or "n/a"
        return string.format("level %.2f | close %s | %s by %.1f pts (%.2f ATR) | ATR %.1f",
            vwap, closeTxt, side, abs(distPts), abs(distATR), atr)
    end

    local function diagnosticNextAction(action, blockers, focusInfo, edgeNow, edgeNeed)
        if action == "BUY" or action == "SELL" then
            return "Execute plan: broker SL/TP live; let smart trail handle BE and lock"
        end
        local raw = (blockers and blockers[1]) and tostring(blockers[1]) or ""
        if string.find(raw, "edge", 1, true) then
            return "Sit on hands - need a cleaner winner between long and short"
        end
        if string.find(raw, "geometry", 1, true) or string.find(raw, "pullback", 1, true) then
            return "Idea OK - wait for price back to fast MA / valid location"
        end
        if string.find(raw, "VWAP", 1, true) or string.find(raw, "fade", 1, true) then
            return "For a fade: need full stretch + RSI extreme + rejection wick"
        end
        if string.find(raw, "evidence", 1, true) or string.find(raw, "probability", 1, true) then
            return "Package too soft - wait for score to clear the bar with edge"
        end
        if string.find(raw, "session", 1, true) then
            return "Outside session - next window is London / London-NY"
        end
        if string.find(raw, "cooldown", 1, true) then
            return "Cooldown after confirmed close - no new ticket until bars elapse"
        end
        if string.find(raw, "spread", 1, true) then
            return "Spread tax too high - wait for normalization"
        end
        if string.find(raw, "risk", 1, true) or string.find(raw, "loss", 1, true) then
            return "Risk brake on - protect the day, no new risk"
        end
        return "Stand aside - next closed bar, same checklist"
    end

    -- AI-community style multi-voice brief (bull desk / bear desk / room consensus).
    local function diagnosticCommunityVoices(action, longInfo, shortInfo, focusInfo, c, edgeNow, edgeNeed)
        local lScore = tonumber(longInfo.score) or 0
        local sScore = tonumber(shortInfo.score) or 0
        local lReq = tonumber(longInfo.required) or 50
        local sReq = tonumber(shortInfo.required) or 50
        local rsi = tonumber(c.rsi) or 50
        local vwap = tonumber(c.vwapDistATR) or 0
        local mom = tonumber(c.momentumATR) or 0
        local geo = tostring(focusInfo.entryType or "n/a")

        local bull = string.format("Long desk: score %.0f/%.0f", lScore, lReq)
        if lScore >= lReq then
            bull = bull .. " - package clears bar"
        elseif lScore + 5 >= lReq then
            bull = bull .. " - close, needs one more factor"
        else
            bull = bull .. " - not enough evidence yet"
        end
        if mom > 0.4 then bull = bull .. "; momentum supportive" end
        if vwap < -1.5 then bull = bull .. "; discounted vs VWAP" end
        if rsi <= 35 then bull = bull .. "; RSI washed out" end

        local bear = string.format("Short desk: score %.0f/%.0f", sScore, sReq)
        if sScore >= sReq then
            bear = bear .. " - package clears bar"
        elseif sScore + 5 >= sReq then
            bear = bear .. " - close, needs one more factor"
        else
            bear = bear .. " - not enough evidence yet"
        end
        if mom < -0.4 then bear = bear .. "; momentum supportive" end
        if vwap > 1.5 then bear = bear .. "; extended vs VWAP" end
        if rsi >= 65 then bear = bear .. "; RSI elevated" end

        local room
        if action == "BUY" then
            room = string.format(
                "Room consensus: LONG - edge %.0f (need %.0f), geometry %s. Majority follows the long desk.",
                edgeNow, edgeNeed, geo)
        elseif action == "SELL" then
            room = string.format(
                "Room consensus: SHORT - edge %.0f (need %.0f), geometry %s. Majority follows the short desk.",
                edgeNow, edgeNeed, geo)
        elseif edgeNow < edgeNeed then
            room = string.format(
                "Room consensus: NO TRADE - desks disagree (edge %.0f < %.0f). Capital stays flat.",
                edgeNow, edgeNeed)
        else
            room = "Room consensus: NO TRADE - gates still open on risk, location, or session."
        end

        local riskNote
        if action == "BUY" or action == "SELL" then
            riskNote = "Risk note: size from stop distance; trail only after BE - do not move SL wider."
        elseif vwap > 2.5 or vwap < -2.5 then
            riskNote = "Risk note: stretched vs VWAP - chase entries are low quality; fades need full checklist."
        elseif (tonumber(c.atr) or 0) < 4 then
            riskNote = "Risk note: quiet ATR - noise and spread dominate; prefer larger stops or stand aside."
        else
            riskNote = "Risk note: no edge worth paying spread for - patience is the position."
        end

        return bull, bear, room, riskNote
    end

    local c = Context
    local sp = spreadPips(p)
    local eq = getAccountEquity()
    local dd = 0.0
    if eq ~= nil and Rt.sessionStartEquity ~= nil and Rt.sessionStartEquity > 0 then
        dd = (Rt.sessionStartEquity - eq) / Rt.sessionStartEquity * 100.0
    end

    local cooldownBars, cooldownOK, cooldownSource
    if acceptedState ~= nil then
        cooldownBars = acceptedState.cooldownBars
        cooldownOK = acceptedState.cooldownOK
        cooldownSource = acceptedState.cooldownSource
    else
        local cooldownPeriod
        cooldownPeriod, cooldownSource = cooldownReferencePeriod()
        cooldownBars = cooldownPeriod ~= nil and (p - cooldownPeriod) or nil
        cooldownOK = cooldownPeriod == nil or cooldownBars >= Cfg.MinBarsBetweenTrades
    end
    local cooldownText = cooldownBars ~= nil and tostring(cooldownBars) or "ready"
    if cooldownBars ~= nil and cooldownSource ~= nil then
        cooldownText = cooldownText .. " after " .. cooldownSource
    end

    local focusLong
    if acceptedState ~= nil and acceptedState.focusSide ~= nil then
        focusLong = acceptedState.focusSide == "B"
    else
        focusLong = longInfo.score >= shortInfo.score
    end
    local focusName = focusLong and "LONG" or "SHORT"
    local focusInfo = focusLong and longInfo or shortInfo
    local otherName = focusLong and "SHORT" or "LONG"
    local otherInfo = focusLong and shortInfo or longInfo

    local blockers = {}
    local passed = {}
    local function addAll(dst, src)
        if src == nil then return end
        for i = 1, #src do dst[#dst + 1] = src[i] end
    end
    addAll(blockers, globalBlockers)
    addAll(blockers, focusInfo.blockers)
    addAll(passed, globalPassed)
    addAll(passed, focusInfo.passed)

    if #blockers == 0 then blockers[1] = "none" end
    if #passed == 0 then passed[1] = "none" end

    local adxValue = tonumber(c.adx) or 0.0
    local plusDIValue = tonumber(c.plusDirection) or 0.0
    local minusDIValue = tonumber(c.minusDirection) or 0.0
    local adxState = "neutral"
    if adxValue >= 22.0 then
        if plusDIValue > minusDIValue then adxState = "trending-up"
        elseif minusDIValue > plusDIValue then adxState = "trending-down"
        else adxState = "trending" end
    elseif adxValue < 18.0 then
        adxState = "ranging"
    else
        adxState = "transition"
    end

    local tradeCount, buyCount, sellCount = ownTradesSnapshot()
    local posText = "FLAT"
    if buyCount > 0 and sellCount > 0 then posText = "LONG+SHORT"
    elseif buyCount > 0 then posText = "LONG"
    elseif sellCount > 0 then posText = "SHORT" end

    local action = tostring(decision)
    if action == "NO TRADE" then action = "WAIT" end

    local marketSessionText = tostring(Rt.activeMarketSession or "UNAVAILABLE")
    if Rt.activeMarketSessionClock ~= nil then
        local utcMinutes = math.floor(Rt.activeMarketSessionClock * 1440 + 0.5) % 1440
        marketSessionText = string.format("%s@%02d:%02dUTC", marketSessionText,
            math.floor(utcMinutes / 60), utcMinutes % 60)
    end
    local focusMLText = "OFF"
    if focusInfo.ml ~= nil and focusInfo.ml.probability ~= nil then
        focusMLText = string.format("%s:%.1f%%:n%d", focusInfo.ml.status,
            focusInfo.ml.probability * 100.0, focusInfo.ml.samples or 0)
    elseif focusInfo.ml ~= nil then
        focusMLText = tostring(focusInfo.ml.status)
    end

    local trail = trailingDiagnostic(p)
    local trailText = "brokerRatchet=" .. (trail.brokerTrail and "ON" or "OFF")
        .. " stops=[" .. (#trail.entries > 0 and table.concat(trail.entries, ",") or "NONE") .. "]"
    if #trail.blockedExits > 0 then
        trailText = trailText .. " EXIT_BLOCKED(FIFO)[" .. table.concat(trail.blockedExits, ",") .. "]"
    end

    local edgeNow = abs((longInfo.score or 0) - (shortInfo.score or 0))
    local edgeNeed = Cfg.ProbabilityEdgeMin or 10
    if Cfg.UseSmartEvidence and acceptedState == nil then
        -- Display adaptive edge when smart evidence is on (leader approx = focus).
        local leaderSide = focusLong and "B" or "S"
        edgeNeed = smartRequiredEdge(leaderSide, longInfo.htf, shortInfo.htf)
    end

    local quality = diagnosticQualityGrade(focusInfo.score, focusInfo.required)
    local why = diagnosticWhyText(action, blockers, focusInfo)
    local confidence = diagnosticConfidence(action, focusInfo.score, focusInfo.required,
        edgeNow, edgeNeed, quality)
    local marketRead = diagnosticMarketRead(c, focusInfo, adxValue, adxState)
    local vwapLine = diagnosticVWAPLine(c)
    local nextAction = diagnosticNextAction(action, blockers, focusInfo, edgeNow, edgeNeed)
    local bullVoice, bearVoice, roomVoice, riskNote = diagnosticCommunityVoices(
        action, longInfo, shortInfo, focusInfo, c, edgeNow, edgeNeed)

    local moneyText = "FixedLots / n/a"
    if Cfg.SizingMode == "AdaptiveRisk" then
        if Cfg.UseSmartMoneyManagement then
            local scale, note = smartRiskScale(focusInfo.score, focusInfo.required, focusInfo.regime)
            moneyText = string.format("AdaptiveRisk x%.2f [%s]", scale, tostring(note))
        else
            moneyText = "AdaptiveRisk x1.00 [smart MM off]"
        end
    end

    local manageText = "smartTM=" .. (Cfg.UseSmartTradeManagement and "ON" or "OFF")
        .. " regimeFlipExit=" .. (Cfg.ExitOnRegimeFlip and "ON" or "OFF")
        .. " emaVwapThesisExit=" .. (Cfg.ExitOnThesisInvalidation and "ON" or "OFF")
    if Cfg.UseSmartTradeManagement then
        manageText = manageText .. string.format(" lock@%.1fR tight@%.1fR CHOCH=%s giveback=%s",
            Cfg.LockProfitR or 1.5, Cfg.TrailTightenAfterR or 2.0,
            yn(Cfg.ExitOnAdverseCHOCH), yn(Cfg.UseGivebackExit))
    end

    local verdictIcon = action == "WAIT" and "WAIT" or action
    local topBlockers = {}
    for i = 1, min(3, #blockers) do
        if blockers[i] ~= "none" then topBlockers[#topBlockers + 1] = blockers[i] end
    end
    local topBlockerText = #topBlockers > 0 and table.concat(topBlockers, " | ") or "none"

    local structureState = Rt.marketStructure or {}
    local lastHighText = "NA"
    if structureState.lastHigh ~= nil and validNumber(structureState.lastHigh.value) then
        lastHighText = tostring(structureState.lastHigh.label) .. " "
            .. string.format("%.5f", structureState.lastHigh.value)
    end
    local lastLowText = "NA"
    if structureState.lastLow ~= nil and validNumber(structureState.lastLow.value) then
        lastLowText = tostring(structureState.lastLow.label) .. " "
            .. string.format("%.5f", structureState.lastLow.value)
    end
    local structureWeightText = "NONE"
    if (structureState.appliedWeight or 0) > 0 then
        structureWeightText = tostring(structureState.appliedSide) .. "+"
            .. string.format("%.2f", structureState.appliedWeight)
    end

    local regimeDetail = tostring(Rt.currentRegime)
        .. " | base " .. tostring(Rt.currentBaseRegime)
        .. " | best " .. tostring(Rt.regimeBestName) .. " " .. string.format("%.1f", Rt.regimeBestScore or 0)
        .. " | second " .. tostring(Rt.regimeSecondName) .. " " .. string.format("%.1f", Rt.regimeSecondScore or 0)
        .. " | margin " .. string.format("%.1f/%.1f", Rt.regimeEffectiveMargin or 0, Cfg.RegimeConfidenceMargin)

    -- Compact primary block (always built). Full detail is optional.
    local shortBlock = topBlockers[1] or "none"
    if shortBlock ~= "none" and string.len(shortBlock) > 90 then
        shortBlock = string.sub(shortBlock, 1, 87) .. "..."
    end

    local lines
    if Cfg.CompactDiagnostics ~= false then
        lines = {
            string.format("== AI COMMUNITY DESK  ARS v%s  BAR %s  %s ==",
                STRATEGY_VERSION, tostring(p), marketSessionText),
            string.format("CONSENSUS   | %s  |  conf %s  |  grade %s",
                verdictIcon, confidence, quality),
            string.format("STATE AI    | %s | bias %s | conf %.0f/100 | %s",
                tostring(Rt.smartState or "UNKNOWN"),
                tostring(Rt.smartStateBias or "NEUTRAL"),
                tonumber(Rt.smartStateConfidence) or 0,
                tostring(Rt.smartStateNote or "")),
            (function()
                local pulse = Rt.livePulse
                if type(pulse) ~= "table" then
                    return "PULSE       | n/a"
                end
                return string.format(
                    "PULSE       | %s/%s | sessionHeat=%.2f | friendly=%.0f%% | score%+.0f edge%+.0f riskx%.2f | %s",
                    tostring(pulse.volState or "?"), tostring(pulse.energyState or "?"),
                    tonumber(pulse.sessionHeat) or 0,
                    (tonumber(pulse.friendliness) or 0) * 100.0,
                    tonumber(pulse.scoreAdd) or 0, tonumber(pulse.edgeAdd) or 0,
                    tonumber(pulse.riskMult) or 1.0, tostring(pulse.note or "neutral"))
            end)(),
            string.format("TYPES       | profile %s | live %s",
                tostring(Cfg.TradeTypeProfile or "MANUAL"), tradeTypesSummaryText()),
            string.format("STRUCTURE   | %s | phase %s | q %.0f conf %.0f | %s | BOS %s/%s CHOCH %s",
                tostring(structureState.bias or "UNKNOWN"),
                tostring(structureState.phase or "NONE"),
                tonumber(structureState.quality) or 0,
                tonumber(structureState.confidence) or 0,
                tostring(structureState.sequence or "NA"),
                yn(structureState.bosUp), yn(structureState.bosDown),
                structureState.choch and tostring(structureState.chochDirection or "Y") or "N"),
            string.format("TAPE        | %s", marketRead),
            string.format("VWAP        | %s", vwapLine),
            string.format("KEY LEVELS  | %s",
                (type(Context.keyLevels) == "table" and Context.keyLevels.text)
                    and tostring(Context.keyLevels.text) or "off"),
            string.format("BULL CASE   | %s", bullVoice),
            string.format("BEAR CASE   | %s", bearVoice),
            string.format("ROOM TAKE   | %s", roomVoice),
            string.format("ANALYSIS    | %s", why),
            string.format("PLAYBOOK    | %s", nextAction),
            string.format("RISK        | %s", riskNote),
            string.format("BOOK        | %s | L %.0f / S %.0f | cd %s | losses %s/%s | HTF %s | geo %s",
                posText,
                tonumber(longInfo.score) or 0, tonumber(shortInfo.score) or 0,
                cooldownText,
                tostring(Rt.consecutiveLosses), tostring(Cfg.MaxConsecutiveLosses),
                tostring(focusInfo.htf or "n/a"),
                tostring(focusInfo.entryType or "n/a")),
        }
        if shortBlock ~= "none" and action == "WAIT" then
            lines[#lines + 1] = string.format("GATE        | %s", shortBlock)
        end
    else
        lines = {
            "======== ARS v" .. STRATEGY_VERSION .. "  BAR " .. tostring(p) .. "  " .. marketSessionText .. " ========",
            "CONSENSUS | " .. verdictIcon .. " | conf " .. confidence .. " | " .. quality,
            "BULL CASE | " .. bullVoice,
            "BEAR CASE | " .. bearVoice,
            "ROOM TAKE | " .. roomVoice,
            "ANALYSIS | " .. why,
            "PLAYBOOK | " .. nextAction,
            "RISK NOTE | " .. riskNote,
            "TAPE     | " .. marketRead,
            "VWAP     | " .. vwapLine,
            "FOCUS    | " .. focusName
                .. string.format("  score %.0f need %.0f  |  edge %.0f need %.0f  |  quality %s",
                    tonumber(focusInfo.score) or 0, tonumber(focusInfo.required) or 0,
                    edgeNow, edgeNeed, quality),
            "SETUP    | regime " .. tostring(focusInfo.regime)
                .. " | type " .. tostring(focusInfo.entryType or "n/a")
                .. " | HTF " .. tostring(focusInfo.htf),
            "MONEY    | " .. moneyText,
            "MANAGE   | book=" .. posText .. " | " .. manageText,
            "TOP BLOCK| " .. topBlockerText,
            "REGIME   | " .. regimeDetail,
            "MARKET   | " .. string.format("%.5f", c.close)
                .. " | RSI " .. string.format("%.1f", c.rsi)
                .. " | mom " .. string.format("%+.2fATR", c.momentumATR)
                .. " | ADX " .. string.format("%.1f", adxValue) .. " " .. adxState
                .. " | DI+/- " .. string.format("%.0f/%.0f", plusDIValue, minusDIValue),
            "LOCATION | " .. vwapLine
                .. " | fast gap " .. string.format("%.2fATR", safeDiv(abs(c.close - c.emaFast), c.atr, 0))
                .. " | spread " .. string.format("%.2f/%.2fp", sp, Cfg.MaxSpreadPips),
            "STRUCTURE| " .. tostring(structureState.bias or "UNKNOWN")
                .. " | phase " .. tostring(structureState.phase or "NONE")
                .. " | q " .. string.format("%.0f", structureState.quality or 0)
                .. " conf " .. string.format("%.0f", structureState.confidence or 0)
                .. " | H " .. lastHighText .. " | L " .. lastLowText
                .. " | BOS " .. yn(structureState.bosUp) .. "/" .. yn(structureState.bosDown)
                .. " | CHOCH " .. yn(structureState.choch)
                .. ((structureState.choch and structureState.chochDirection ~= "NONE")
                    and ("_" .. tostring(structureState.chochDirection)) or "")
                .. " | seq " .. tostring(structureState.sequence or "NA")
                .. " | range " .. string.format("%.2fATR", structureState.swingRangeATR or 0),
            "EVIDENCE | dir " .. string.format("%.0f", focusInfo.parts.direction or 0)
                .. " str " .. string.format("%.0f", focusInfo.parts.structure or 0)
                .. " loc " .. string.format("%.0f", focusInfo.parts.location or 0)
                .. " htf " .. string.format("%.0f", focusInfo.parts.htf or 0)
                .. " mom " .. string.format("%.0f", focusInfo.parts.momentum or 0)
                .. " env " .. string.format("%.0f", focusInfo.parts.environment or 0)
                .. " smart " .. string.format("%+.0f", tonumber(focusInfo.parts.smartDelta) or 0),
            "COMPARE  | LONG " .. string.format("%.0f/%.0f", longInfo.score or 0, longInfo.required or 0)
                .. " | SHORT " .. string.format("%.0f/%.0f", shortInfo.score or 0, shortInfo.required or 0),
            "RISK     | cd " .. cooldownText .. (cooldownOK and " OK" or " BLOCKED")
                .. " | dd " .. string.format("%.2f%%", dd)
                .. " | losses " .. tostring(Rt.consecutiveLosses) .. "/" .. tostring(Cfg.MaxConsecutiveLosses)
                .. " | ML " .. focusMLText,
            "POSITION | " .. posText
                .. " | " .. tostring(tradeCount) .. "/" .. tostring(Cfg.MaxPositions)
                .. " | " .. trailText,
            "BLOCKERS | " .. (#blockers == 1 and blockers[1] == "none" and "none"
                or table.concat(blockers, " || ")),
        }
    end

    if Rt.executionQuality ~= nil then table.insert(lines, 1, Rt.executionQualityText()) end
    table.insert(lines, 1, SmartAI.marketOutlookText())
    local msg = table.concat(lines, "\n")

    writeCSVLog("BAR", msg, closedBarEndDate(p) or Rt.Source:date(p))
    if Cfg.ShowDebug then emitTerminalDiagnostic(msg) end
end

local function makeEntryInfo(side, regime)
    local candidates = regime and {{name=regime}} or probabilityRegimeForSide(side, true)
    if #candidates == 0 then candidates = {{name="NONE"}} end
    local chosen, selectedOK = nil, false
    for i = 1, #candidates do
        local name = candidates[i].name
        local b, pass, part, value, threshold, ht, st, key, anchor, kind, geometry, globalKey =
            collectEntryDiagnostics(side, name)
        local qualified = #b == 0
        if chosen == nil or (qualified and not selectedOK)
            or (qualified == selectedOK and value > chosen.score) then
            chosen = {regime=name, blockers=b, passed=pass, parts=part, score=value,
                required=threshold, htf=ht, structure=st, setupKey=key,
                setupAnchor=anchor, entryType=kind, geometryText=geometry, globalSetupKey=globalKey}
            selectedOK = qualified
        end
    end
    regime = chosen.regime
    local blockers, passed, parts, score, required = chosen.blockers, chosen.passed,
        chosen.parts, chosen.score, chosen.required
    local htf, structure, setupKey, setupAnchor, entryType, geometryText = chosen.htf,
        chosen.structure, chosen.setupKey, chosen.setupAnchor, chosen.entryType, chosen.geometryText
    passed[#passed + 1] = string.format("selected %s from %d candidate(s); deterministic=%s",
        regime, #candidates, yn(selectedOK))
    local mlOK, ml = pcall(function() return SmartAI.evaluateEntry(side, regime, score, required, entryType) end)
    if not mlOK then
        local problem = tostring(ml)
        ml = {status=Cfg.MLMode == "FILTER" and "ERROR_BLOCK" or "ERROR_OBSERVE",
            probability=nil, features=nil, block=Cfg.MLMode == "FILTER",
            samples=Rt.ML ~= nil and Rt.ML.samples or 0, contributors="error"}
        if Rt.ML ~= nil and Rt.ML.lastEvaluationError ~= problem then
            Rt.ML.lastEvaluationError = problem
            alert("SMART AI EVALUATION FAILED: " .. tostring(ml.status) .. " | " .. problem)
        end
    end
    if ml.block and ml.probability == nil then
        blockers[#blockers + 1] = "SmartAI FILTER unavailable: entry blocked"
    end
    if ml.probability ~= nil then
        local thr = tonumber(ml.threshold) or Cfg.MLProbabilityThreshold or 0.55
        local mlText = string.format(
            "SmartAI=%s p=%.1f%% thr=%.1f%% log=%.1f%% emp=%.1f%% n=%d/%d drivers=%s",
            ml.status, ml.probability * 100.0, thr * 100.0,
            (tonumber(ml.logistic) or ml.probability) * 100.0,
            (tonumber(ml.empiric) or 0.5) * 100.0,
            ml.samples or 0, Cfg.MLMinSamples, tostring(ml.contributors or "NA"))
        if ml.block then blockers[#blockers + 1] = mlText
        else passed[#passed + 1] = mlText end
    elseif Cfg.MLMode == "OFF" then
        passed[#passed + 1] = "SmartAI=OFF"
    else
        passed[#passed + 1] = "SmartAI=" .. tostring(ml.status)
    end
    return {blockers=blockers, passed=passed, parts=parts, score=score, required=required, regime=regime,
        htf=htf, structure=structure, setupKey=setupKey, setupAnchor=setupAnchor,
        entryType=entryType, geometryText=geometryText, ml=ml}
end

-- =========================
-- Main closed-bar evaluator
-- =========================

-- =========================
-- v9.1 clean entry engine
-- Entry-only replacement. The original broker/risk/management stack below
-- remains authoritative after an entry is accepted.
-- =========================
function Rt.cleanPriorExtremes(p, lookback)
    local first = max(Rt.Source:first(), p - (lookback or 12))
    local hi, lo = -math.huge, math.huge
    for i = first, p - 1 do
        local h, l = Rt.Source.high[i], Rt.Source.low[i]
        if validNumber(h) then hi = max(hi, h) end
        if validNumber(l) then lo = min(lo, l) end
    end
    if hi == -math.huge then hi = Context.high end
    if lo == math.huge then lo = Context.low end
    return hi, lo
end

function Rt.stopGeometryStatus(stopDistance)
    local pip = sourcePipSize()
    if not validNumber(stopDistance) or not validNumber(pip) or pip <= 0 then
        return false, "STOP_GEOMETRY_INVALID"
    end
    local stopPips = stopDistance / pip
    local maxStop = tonumber(Cfg.MaxEntryStopPips) or 0
    if maxStop > 0 and stopPips > maxStop + 1e-9 then
        return false, string.format("STOP_GEOMETRY_TOO_WIDE required=%.2fp max=%.2fp", stopPips, maxStop)
    end
    return true, string.format("ENTRY_STOP_GATE | required=%.2f max=%s PASS",
        stopPips, maxStop > 0 and string.format("%.2f", maxStop) or "OFF")
end

function Rt.rangeGeometryStatus(side, p, stopDistance, targetDistance)
    local pip = sourcePipSize()
    local hi, lo = Rt.cleanPriorExtremes(p, Cfg.CleanRangeLookback)
    if not validNumber(hi) or not validNumber(lo) or hi <= lo or not validNumber(pip) or pip <= 0 then
        return false, "RANGE_GEOMETRY_UNAVAILABLE", "RANGE_GEOMETRY | unavailable"
    end
    local width = hi - lo
    local room = side == "B" and (hi - Context.close) or (Context.close - lo)
    local ratio = safeDiv(stopDistance, width, math.huge)
    local maxFrac = tonumber(Cfg.MaxRangeStopFraction) or 0.50
    local text = string.format(
        "RANGE_GEOMETRY | lookback=%d high=%.2f low=%.2f width=%.2f entry=%.2f requiredStop=%.2f stopRangeRatio=%.2f maxStopRangeRatio=%.2f target=%.2f roomToOppositeEdge=%.2f",
        Cfg.CleanRangeLookback, hi, lo, width / pip, Context.close,
        stopDistance / pip, ratio, maxFrac, targetDistance / pip, room / pip)
    if Cfg.UseRangeStopWidthGate and ratio > maxFrac + 1e-9 then
        return false, string.format("RANGE_STOP_TOO_LARGE ratio=%.2f max=%.2f", ratio, maxFrac), text .. " WAIT reason=RANGE_STOP_TOO_LARGE"
    end
    if Cfg.CleanRangeRequire2RRoom and room + 1e-12 < targetDistance then
        return false, string.format("INSUFFICIENT_RANGE_TARGET_ROOM room=%.2fp target=%.2fp", room / pip, targetDistance / pip),
            text .. " WAIT reason=INSUFFICIENT_RANGE_TARGET_ROOM"
    end
    return true, "OK", text .. " PASS"
end

function Rt.cleanEMAStack(side)
    local c = Context
    if side == "B" then return c.emaFast > c.emaMed and c.emaMed > c.emaSlow end
    if side == "S" then return c.emaFast < c.emaMed and c.emaMed < c.emaSlow end
    return false
end

function Rt.cleanState()
    local c = Context
    local atr = c.atr
    local slopeATR = safeDiv(c.emaFastSlope, atr, 0)
    local dmiLong = safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
    local dmiShort = safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
    local upCore = Rt.cleanEMAStack("B")
        or ((not Cfg.CleanRequireFullEMAStack) and c.emaFast > c.emaMed)
    local downCore = Rt.cleanEMAStack("S")
        or ((not Cfg.CleanRequireFullEMAStack) and c.emaFast < c.emaMed)
    local strongUp = c.momentumATR >= Cfg.CleanImpulseStateATR and slopeATR > 0
        and c.plusDirection > c.minusDirection and upCore
    local strongDown = c.momentumATR <= -Cfg.CleanImpulseStateATR and slopeATR < 0
        and c.minusDirection > c.plusDirection and downCore
    if strongUp then return "TREND_UP" end
    if strongDown then return "TREND_DOWN" end
    local upBias = upCore and c.adx >= Cfg.MinimumTrendADX
        and dmiLong >= Cfg.CleanMinDMIRatio
    local downBias = downCore and c.adx >= Cfg.MinimumTrendADX
        and dmiShort >= Cfg.CleanMinDMIRatio
    local trendUp = upBias and c.momentumATR > 0
    local trendDown = downBias and c.momentumATR < 0
    if trendUp and not trendDown then return "TREND_UP" end
    if trendDown and not trendUp then return "TREND_DOWN" end

    -- A limited counter-momentum retracement does not erase an otherwise
    -- coherent directional trend. Preserve the trend side and classify the
    -- market as a pullback state so the engine waits for EMA9/EMA20 reclaim
    -- rather than falling into generic TRANSITION/NONE.
    local maxCounter = Cfg.CleanPullbackStateMaxCounterMomentumATR or 0.75
    if upBias and c.momentumATR <= 0 and c.momentumATR >= -maxCounter then
        return "TREND_UP_PULLBACK"
    end
    if downBias and c.momentumATR >= 0 and c.momentumATR <= maxCounter then
        return "TREND_DOWN_PULLBACK"
    end
    local compression = safeDiv(max(c.emaFast, max(c.emaMed, c.emaSlow))
        - min(c.emaFast, min(c.emaMed, c.emaSlow)), atr, 0)
    if c.adx < Cfg.CleanRangeMaxADX and compression <= Cfg.CleanRangeMaxMACompressionATR
        and abs(c.momentumATR) <= Cfg.CleanRangeMaxMomentumATR then return "RANGE" end
    return "TRANSITION"
end

function Rt.cleanTrigger(side, bodyMin, closeLocMin)
    local sign = side == "B" and 1 or -1
    local body = sign * safeDiv(Context.close - Context.open, Context.atr, 0)
    local range = max(Context.high - Context.low, sourcePipSize())
    local closeLoc = clamp(safeDiv(Context.close - Context.low, range, 0.5), 0, 1)
    local locationOK = (side == "B" and closeLoc >= closeLocMin)
        or (side == "S" and closeLoc <= 1 - closeLocMin)
    return body >= bodyMin and locationOK, body, closeLoc
end

function Rt.cleanBreakout(side, p)
    if not Cfg.AllowBreakoutTrades then return false end
    local c = Context
    local sign = side == "B" and 1 or -1
    local hi, lo = Rt.cleanPriorExtremes(p, Cfg.CleanBreakoutLookback)
    local broken = side == "B" and c.close > hi + Cfg.CleanBreakoutBufferATR * c.atr
        or side == "S" and c.close < lo - Cfg.CleanBreakoutBufferATR * c.atr
    local core = (not Cfg.CleanRequireFullEMAStack) or Rt.cleanEMAStack(side)
    local dmi = side == "B" and safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
        or safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
    local trigger = Rt.cleanTrigger(side, Cfg.CleanBreakoutBodyATR, Cfg.CleanBreakoutCloseLoc)
    local gap = safeDiv(abs(c.close - c.emaFast), c.atr, math.huge)
    local directionalVWAP = sign * (tonumber(c.vwapDistATR) or 0)
    local vwapOK = not Cfg.CleanUseVWAPQuality
        or directionalVWAP <= Cfg.CleanBreakoutMaxVWAPStretchATR
    if broken and core and c.adx >= Cfg.CleanBreakoutMinADX
        and dmi >= Cfg.CleanBreakoutMinDMIRatio
        and sign * c.momentumATR >= Cfg.CleanBreakoutMomentumATR
        and trigger and gap <= Cfg.CleanBreakoutMaxFastGapATR and vwapOK then
        return true, side == "B" and "BREAKOUT_UP" or "BREAKOUT_DOWN", "BREAKOUT",
            "directional range break", side == "B" and hi or lo
    end
    return false
end

function Rt.cleanRecentRebase(side, p)
    local c = Context
    local lookback = max(1, Cfg.CleanContinuationRebaseLookback or 4)
    local tol = (Cfg.CleanContinuationRebaseTouchATR or 0.35) * c.atr
    local first = max(Rt.Source:first(), p - lookback)
    for i = first, p - 1 do
        local low, high = Rt.Source.low[i], Rt.Source.high[i]
        local ef, em = Ind.emaFast[i], Ind.emaMed[i]
        if validNumber(low) and validNumber(high) and validNumber(ef) and validNumber(em) then
            if side == "B" and (low <= ef + tol or low <= em + tol) then return true end
            if side == "S" and (high >= ef - tol or high >= em - tol) then return true end
        end
    end
    return false
end

function Rt.cleanContinuation(side, state, p)
    if not Cfg.AllowTrendTrades then return false end
    local c = Context
    if side == "B" and state ~= "TREND_UP" or side == "S" and state ~= "TREND_DOWN" then return false end
    local sign = side == "B" and 1 or -1
    local core = (not Cfg.CleanRequireFullEMAStack) or Rt.cleanEMAStack(side)
    local dmi = side == "B" and safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
        or safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
    local trigger = Rt.cleanTrigger(side, Cfg.CleanTriggerBodyATR, Cfg.CleanTriggerCloseLoc)
    local priceSide = sign * (c.close - c.emaFast) >= -Cfg.CleanContinuationEMARejectATR * c.atr
    local gap = safeDiv(abs(c.close - c.emaFast), c.atr, math.huge)
    local directionalVWAP = sign * (tonumber(c.vwapDistATR) or 0)
    local vwapOK = not Cfg.CleanUseVWAPQuality
        or directionalVWAP <= Cfg.CleanContinuationMaxVWAPStretchATR
    local directionalMomentum = sign * c.momentumATR
    local momentumOK = directionalMomentum >= Cfg.CleanContinuationMomentumATR
        and directionalMomentum <= (Cfg.CleanContinuationMaxMomentumATR or 1.50)
    local rebased = Rt.cleanRecentRebase(side, p)
    if core and c.adx >= Cfg.MinimumTrendADX and dmi >= Cfg.CleanMinDMIRatio
        and momentumOK and rebased
        and trigger and priceSide and gap <= Cfg.CleanContinuationMaxFastGapATR and vwapOK then
        return true, side == "B" and "TRENDING_UP" or "TRENDING_DOWN", "CONTINUATION",
            "recent EMA9/EMA20 re-base + continuation trigger"
    end
    return false
end

function Rt.cleanPullbackClassic(side)
    if not Cfg.AllowTrendTrades then return false end
    local c = Context
    local sign = side == "B" and 1 or -1
    local core = (not Cfg.CleanRequireFullEMAStack) or Rt.cleanEMAStack(side)
    if not core then return false end
    local tol = Cfg.CleanPullbackTouchATR * c.atr
    local touchedFast = (side == "B" and c.low <= c.emaFast + tol)
        or (side == "S" and c.high >= c.emaFast - tol)
    local touchedMed = (side == "B" and c.low <= c.emaMed + tol)
        or (side == "S" and c.high >= c.emaMed - tol)
    local reclaimFast = sign * (c.close - c.emaFast) / c.atr >= Cfg.CleanPullbackReclaimATR
    local reclaimMed = sign * (c.close - c.emaMed) / c.atr >= Cfg.CleanPullbackReclaimATR
    local trigger = Rt.cleanTrigger(side, Cfg.CleanTriggerBodyATR, Cfg.CleanTriggerCloseLoc)
    local dmi = side == "B" and safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
        or safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
    local gap = safeDiv(abs(c.close - c.emaFast), c.atr, math.huge)
    local directionalVWAP = sign * (tonumber(c.vwapDistATR) or 0)
    local vwapOK = not Cfg.CleanUseVWAPQuality
        or directionalVWAP <= (Cfg.CleanPullbackMaxVWAPStretchATR or 20.0)
    -- Pair the reclaim with the EMA that was actually retested. A deeper EMA20
    -- retest also crosses EMA9, so test EMA20 first to keep the setup label and
    -- geometry truthful.
    local locationOK, locationWhy = false, nil
    if touchedMed and reclaimMed then
        locationOK, locationWhy = true, "EMA20 reclaim"
    elseif touchedFast and reclaimFast then
        locationOK, locationWhy = true, "EMA9 reclaim"
    elseif not touchedMed and not touchedFast then
        -- A pullback can touch on one closed candle and confirm on the next.
        -- Preserve the current-bar reclaim, candle, DMI, EMA-gap and VWAP gates;
        -- accept only the most recent retest in the bounded lookback.
        local lookback = max(0, math.floor(tonumber(Cfg.CleanPullbackRetestLookbackBars) or 0))
        local period = tonumber(c.p)
        if lookback > 0 and validNumber(period) and Rt.Source ~= nil then
            period = math.floor(period)
            local first = max(Rt.Source:first(), period - lookback)
            for i = period - 1, first, -1 do
                local barLow, barHigh = Rt.Source.low[i], Rt.Source.high[i]
                local barATR = Ind.atr[i]
                local barFast, barMed = Ind.emaFast[i], Ind.emaMed[i]
                if validNumber(barLow) and validNumber(barHigh) and validNumber(barATR)
                    and barATR > 0 and validNumber(barFast) and validNumber(barMed) then
                    local barTol = Cfg.CleanPullbackTouchATR * barATR
                    local retestedMed = side == "B" and barLow <= barMed + barTol
                        or side == "S" and barHigh >= barMed - barTol
                    local retestedFast = side == "B" and barLow <= barFast + barTol
                        or side == "S" and barHigh >= barFast - barTol
                    if retestedMed or retestedFast then
                        if retestedMed and reclaimMed then
                            locationOK, locationWhy = true, "EMA20 recent retest reclaim"
                        elseif retestedFast and reclaimFast then
                            locationOK, locationWhy = true, "EMA9 recent retest reclaim"
                        end
                        break
                    end
                end
            end
        end
    end
    if locationOK and trigger and c.adx >= Cfg.MinimumTrendADX
        and dmi >= Cfg.CleanPullbackMinDMIRatio and gap <= Cfg.CleanPullbackMaxFastGapATR
        and vwapOK then
        return true, side == "B" and "TRENDING_UP" or "TRENDING_DOWN", "EMA_PULLBACK", locationWhy
    end
    return false
end

function Rt.cleanPullbackUpgradeEnabled()
    local mode = Cfg.EntryEngineMode or "CLEAN"
    return Cfg.CleanPullbackMode == "UPGRADED"
        and (mode == "CLEAN" or mode == "SHADOW" or mode == "HYBRID_CONFIRM")
end

function Rt.cleanPullbackDirection(side)
    local c = Context
    local sign = side == "B" and 1 or -1
    if (side ~= "B" and side ~= "S") or not validNumber(c.atr) or c.atr <= 0
        or not validNumber(c.emaFast) or not validNumber(c.emaMed)
        or not validNumber(c.emaSlow) or not validNumber(c.adx)
        or not validNumber(c.plusDirection) or not validNumber(c.minusDirection)
        or not validNumber(c.momentumATR) then return false, nil, "PULLBACK_DIRECTION_DATA" end
    if sign * (c.emaFast - c.emaMed) <= 0 then return false, nil, "EMA9_20_DIRECTION" end
    if c.adx < Cfg.MinimumTrendADX then
        return false, nil, string.format("PULLBACK_ADX %.1f < %.1f", c.adx, Cfg.MinimumTrendADX)
    end
    local dmi = side == "B" and safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
        or safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
    local minDMI = max(Cfg.CleanMinDMIRatio, Cfg.CleanPullbackMinDMIRatio)
    if dmi < minDMI then return false, nil, string.format("PULLBACK_DMI %.2f < %.2f", dmi, minDMI) end
    local maxCounter = Cfg.CleanPullbackStateMaxCounterMomentumATR or 0.75
    if sign * c.momentumATR < -maxCounter then
        return false, nil, string.format("PULLBACK_COUNTER_MOM %.2f > %.2f", -sign * c.momentumATR, maxCounter)
    end
    if Rt.cleanEMAStack(side) then return true, "ESTABLISHED", "full EMA stack + ADX/DMI" end
    if not validNumber(c.emaFastSlope) or not validNumber(c.emaMedSlope) then
        return false, nil, "EARLY_TREND_SLOPE_DATA"
    end
    local fastSlope, medSlope = sign * c.emaFastSlope / c.atr, sign * c.emaMedSlope / c.atr
    local minSlope = Cfg.CleanPullbackMinSlopeATR or 0
    if fastSlope <= minSlope or medSlope <= minSlope then
        return false, nil, string.format("EARLY_TREND_SLOPE fast=%.3f med=%.3f require>%.3fATR",
            fastSlope, medSlope, minSlope)
    end
    return true, "EARLY", "EMA9/20 direction + both slopes + ADX/DMI; EMA50 pending"
end

function Rt.cleanPullbackBar(i, currentP)
    if i == currentP then
        return {low=Context.low, high=Context.high, close=Context.close,
            atr=Context.atr, fast=Context.emaFast, med=Context.emaMed}
    end
    if Rt.Source == nil then return nil end
    return {low=Rt.Source.low[i], high=Rt.Source.high[i], close=Rt.Source.close[i],
        atr=Ind.atr[i], fast=Ind.emaFast[i], med=Ind.emaMed[i]}
end

function Rt.cleanPullbackEvents(side)
    local sign = side == "B" and 1 or -1
    local p = tonumber(Context.p)
    if Rt.Source == nil or not validNumber(p) then return {}, "PULLBACK_BAR_DATA" end
    p = math.floor(p)
    local lookback = max(0, math.floor(Cfg.CleanPullbackRetestLookbackBars or 0))
    local first = max(Rt.Source:first() + 1, p - lookback)
    local events, issue = {}, "PULLBACK_NO_VALID_TOUCH"
    local old = Rt.cleanPullbackPending[side]
    if old ~= nil and old.period ~= nil and p - old.period > lookback then issue = "PULLBACK_TOUCH_EXPIRED" end
    -- Rebuild pending events from bounded closed history. This is deterministic
    -- on duplicate callbacks and restart, and never reads a forming/future bar.
    for i = first, p do
        local bar, prev = Rt.cleanPullbackBar(i, p), Rt.cleanPullbackBar(i - 1, p)
        if bar == nil or not validNumber(bar.low) or not validNumber(bar.high)
            or not validNumber(bar.close) or not validNumber(bar.atr) or bar.atr <= 0
            or not validNumber(bar.fast) or not validNumber(bar.med) then
            events, issue = {}, "PULLBACK_HISTORY_DATA"
        elseif sign * (bar.fast - bar.med) <= 0 then
            events, issue = {}, "PULLBACK_DIRECTION_INVALIDATED"
        else
            for _, name in ipairs({"fast", "med"}) do
                local ema = bar[name]
                local adverse = sign * (bar.close - ema) < -(Cfg.CleanPullbackMaxAdverseATR or 0.75) * bar.atr
                if adverse then
                    if events[name] ~= nil then issue = "PULLBACK_ADVERSE_CLOSE" end
                    events[name] = nil
                end
                local tol = Cfg.CleanPullbackTouchATR * bar.atr
                local touched = bar.low <= ema + tol and bar.high >= ema - tol
                if touched and not adverse then
                    -- Approach uses the preceding candle and its own EMA;
                    -- a candle entirely on the wrong side is not a pullback.
                    local approach = prev ~= nil and validNumber(prev.close) and validNumber(prev[name])
                        and validNumber(prev.fast) and validNumber(prev.med)
                        and sign * (prev.fast - prev.med) > 0 and sign * (prev.close - prev[name]) > 0
                    if approach then
                        local date = Rt.Source:date(i)
                        if validNumber(date) then
                            events[name] = {period=i, date=date, ema=name,
                                anchor=side == "B" and bar.low or bar.high}
                        else issue = "PULLBACK_TOUCH_TIME_UNAVAILABLE" end
                    elseif events[name] == nil then issue = "PULLBACK_TREND_SIDE_APPROACH" end
                end
            end
        end
    end
    return events, issue
end

function Rt.cleanPullbackUpgraded(side)
    local c = Context
    local dir, phase, dirWhy = Rt.cleanPullbackDirection(side)
    local detail = {phase=phase, reason=dirWhy, status="WAIT"}
    Rt.cleanPullbackDetails[side] = detail
    if not Cfg.AllowTrendTrades then detail.reason="TREND_ENTRIES_DISABLED"; return false,nil,nil,detail.reason end
    if not dir then Rt.cleanPullbackPending[side]=nil; return false,nil,nil,dirWhy end
    if not validNumber(c.open) or not validNumber(c.close) or not validNumber(c.high)
        or not validNumber(c.low) or c.high <= c.low then
        detail.reason="PULLBACK_CANDLE_DATA"; return false,nil,nil,detail.reason
    end
    local sign = side == "B" and 1 or -1
    local events, issue = Rt.cleanPullbackEvents(side)
    -- Each EMA has its own event and reclaim. A failed current EMA9 reclaim
    -- must not hide a still-valid preceding EMA20 touch.
    local chosen = nil
    for _, name in ipairs({"med", "fast"}) do
        local event = events[name]
        local ema = name == "med" and c.emaMed or c.emaFast
        if event ~= nil and sign * (c.close - ema) / c.atr >= Cfg.CleanPullbackReclaimATR
            and (chosen == nil or event.period > chosen.period) then
            chosen=event -- newest event wins; EMA20 wins only a same-candle tie
        end
    end
    local pending = chosen or events.med or events.fast
    Rt.cleanPullbackPending[side] = pending
    detail.event=pending
    if chosen == nil then
        detail.reason = pending ~= nil and string.format("PULLBACK_RECLAIM fast=%.2f med=%.2f require=%.2fATR",
            sign*(c.close-c.emaFast)/c.atr, sign*(c.close-c.emaMed)/c.atr, Cfg.CleanPullbackReclaimATR) or issue
        return false,nil,nil,detail.reason
    end
    local body = sign * (c.close - c.open) / c.atr
    local loc = side == "B" and (c.close-c.low)/(c.high-c.low) or (c.high-c.close)/(c.high-c.low)
    detail.body, detail.closeLoc = body, loc
    if body < Cfg.CleanTriggerBodyATR then
        detail.reason=string.format("PULLBACK_TRIGGER_BODY %.2f < %.2fATR",body,Cfg.CleanTriggerBodyATR)
        return false,nil,nil,detail.reason
    end
    if loc < Cfg.CleanTriggerCloseLoc then
        detail.reason=string.format("PULLBACK_CLOSE_LOCATION %.2f < %.2f",loc,Cfg.CleanTriggerCloseLoc)
        return false,nil,nil,detail.reason
    end
    local gap = abs(c.close-c.emaFast)/c.atr
    detail.gap=gap
    if gap > Cfg.CleanPullbackMaxFastGapATR then
        detail.reason=string.format("PULLBACK_EMA9_GAP %.2f > %.2fATR",gap,Cfg.CleanPullbackMaxFastGapATR)
        return false,nil,nil,detail.reason
    end
    if Cfg.CleanUseVWAPQuality and (not validNumber(c.vwapDistATR)
        or sign*c.vwapDistATR > Cfg.CleanPullbackMaxVWAPStretchATR) then
        detail.reason=string.format("PULLBACK_VWAP_CAP distance=%s max=%.2fATR",
            tostring(c.vwapDistATR),Cfg.CleanPullbackMaxVWAPStretchATR)
        return false,nil,nil,detail.reason
    end
    detail.status, detail.event = "READY", chosen
    local ema = chosen.ema == "med" and c.emaMed or c.emaFast
    detail.reclaim = sign*(c.close-ema)/c.atr
    detail.reason = string.format("%s EMA%d touch age=%d + confirmed reclaim",
        phase, chosen.ema == "med" and Cfg.MediumPeriod or Cfg.FastPeriod, c.p-chosen.period)
    return true, side == "B" and "TRENDING_UP" or "TRENDING_DOWN", "EMA_PULLBACK", detail.reason, chosen.anchor
end

function Rt.cleanPullbackScore(side)
    local ok = Rt.cleanPullbackUpgraded(side)
    local d = Rt.cleanPullbackDetails[side]
    if not ok or d == nil or d.status ~= "READY" then return 0 end
    local needed = Cfg.CleanPullbackReclaimATR
    local reclaim = 10 + clamp((d.reclaim-needed)/max(needed*3,0.1),0,1)*10
    local trigger = 10 + clamp((d.body-Cfg.CleanTriggerBodyATR)/0.4,0,1)*5
        + clamp((d.closeLoc-Cfg.CleanTriggerCloseLoc)/max(1-Cfg.CleanTriggerCloseLoc,0.01),0,1)*5
    local location = clamp(1-d.gap/max(Cfg.CleanPullbackMaxFastGapATR,0.01),0,1)*15
    local context = Rt.cleanEMAStack(side) and 5 or 0
    local vwap = 0
    if Cfg.CleanUseVWAPQuality then
        local sign = side == "B" and 1 or -1
        local distance = sign*Context.vwapDistATR
        vwap = distance >= 0 and Cfg.CleanVWAPAlignedBonus or -Cfg.CleanVWAPOpposedPenalty
        if distance >= Cfg.CleanPullbackVWAPPenaltyATR then vwap=vwap-Cfg.CleanPullbackVWAPPenaltyScore end
    end
    d.scoreParts = string.format("direction=20 touch=20 reclaim=%.1f candle=%.1f location=%.1f EMA50=%.1f VWAP=%.1f",
        reclaim,trigger,location,context,vwap)
    d.score = clamp(40+reclaim+trigger+location+context+vwap,0,100)
    return d.score
end

function Rt.cleanPullback(side, forceClassic)
    if not forceClassic and Rt.cleanPullbackUpgradeEnabled() then return Rt.cleanPullbackUpgraded(side) end
    return Rt.cleanPullbackClassic(side)
end

function Rt.cleanRange(side, state, p)
    if state ~= "RANGE" or not Cfg.CleanAllowRange or not Cfg.AllowRangeTrades then return false end
    local c = Context
    local hi, lo = Rt.cleanPriorExtremes(p, Cfg.CleanRangeLookback)
    if not validNumber(hi) or not validNumber(lo) or hi <= lo then return false end

    local width = max(hi - lo, sourcePipSize())
    local pos = safeDiv(c.close - lo, width, 0.5)
    local trigger = Rt.cleanTrigger(side, Cfg.CleanTriggerBodyATR, Cfg.CleanTriggerCloseLoc)
    local edgeOK = side == "B" and pos <= Cfg.CleanRangeEdgeFraction
        or side == "S" and pos >= 1 - Cfg.CleanRangeEdgeFraction
    local rsiOK = side == "B" and c.rsi <= Cfg.CleanRangeLongMaxRSI
        or side == "S" and c.rsi >= Cfg.CleanRangeShortMinRSI
    if not edgeOK or not rsiOK or not trigger then return false end

    -- Range trades are mean-reversion setups. They deliberately do NOT require
    -- the directional 9/20/50 trend stack used by trend/pullback/breakout setups.
    -- Instead, reject signs that the range is turning into directional expansion.
    local barRangeATR = safeDiv(c.high - c.low, c.atr, math.huge)
    if barRangeATR >= Cfg.CleanRangeBreakoutCandleATR then return false end
    if c.close > hi or c.close < lo then return false end

    local adverseDMI = side == "B"
        and safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
        or safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
    local adverseMomentum = side == "B" and -c.momentumATR or c.momentumATR
    if adverseDMI >= Cfg.CleanRangeDangerDMIRatio
        and adverseMomentum >= Cfg.CleanRangeDangerMomentumATR then return false end
    if c.adx >= Cfg.CleanRangeDangerADX
        and adverseMomentum >= Cfg.CleanRangeDangerMomentumATR then return false end

    -- Stop/width and target-room geometry are intentionally evaluated later,
    -- after the exact required stop and monetary affordability are known.

    return true, "CHOPPY_RANGE", "RANGE", side == "B" and "lower range edge mean reversion" or "upper range edge mean reversion"
end

function Rt.cleanRangeScore(side, p)
    local c = Context
    local hi, lo = Rt.cleanPriorExtremes(p, Cfg.CleanRangeLookback)
    if not validNumber(hi) or not validNumber(lo) or hi <= lo or not validNumber(c.atr) or c.atr <= 0 then return 0 end
    local width = max(hi - lo, sourcePipSize())
    local pos = clamp(safeDiv(c.close - lo, width, 0.5), 0, 1)
    local edge = side == "B" and pos or (1 - pos)
    local score = 20 -- state already passed RANGE: low ADX, compressed EMAs, low momentum

    -- Location quality: outer 15% excellent, 15-25% good, 25-30% acceptable.
    if edge <= 0.15 then score = score + 20
    elseif edge <= 0.25 then score = score + 15
    elseif edge <= Cfg.CleanRangeEdgeFraction then score = score + 10 end

    -- RSI stretch quality in the mean-reversion direction.
    if side == "B" then
        if c.rsi <= 35 then score = score + 15
        elseif c.rsi <= 40 then score = score + 12
        elseif c.rsi <= Cfg.CleanRangeLongMaxRSI then score = score + 8 end
    else
        if c.rsi >= 65 then score = score + 15
        elseif c.rsi >= 60 then score = score + 12
        elseif c.rsi >= Cfg.CleanRangeShortMinRSI then score = score + 8 end
    end

    if Rt.cleanTrigger(side, Cfg.CleanTriggerBodyATR, Cfg.CleanTriggerCloseLoc) then score = score + 15 end

    -- For a range BUY, being below VWAP provides mean-reversion room; for SELL,
    -- being above VWAP does the same. Mildly wrong-side VWAP is simply unscored,
    -- not treated like a trend-direction failure.
    if Cfg.CleanRangeUseVWAPMeanReversion and validNumber(c.vwap) then
        local meanRevDistATR = side == "B"
            and safeDiv(c.vwap - c.close, c.atr, 0)
            or safeDiv(c.close - c.vwap, c.atr, 0)
        if meanRevDistATR >= 0.50 then score = score + 15
        elseif meanRevDistATR >= 0.20 then score = score + 12
        elseif meanRevDistATR > 0 then score = score + 8 end
    end

    local compression = safeDiv(max(c.emaFast, max(c.emaMed, c.emaSlow))
        - min(c.emaFast, min(c.emaMed, c.emaSlow)), c.atr, math.huge)
    if compression <= 0.20 then score = score + 10
    elseif compression <= 0.30 then score = score + 8
    elseif compression <= Cfg.CleanRangeMaxMACompressionATR then score = score + 5 end

    local st = tostring(c.marketStructureBias or "UNKNOWN")
    if st == (side == "B" and "BULLISH" or "BEARISH") then score = score + 5 end
    return clamp(score, 0, 100)
end

function Rt.cleanScore(side, setup)
    local c = Context
    local sign = side == "B" and 1 or -1
    local score = 0
    if Rt.cleanEMAStack(side) then score = score + 20 end
    local dmi = side == "B" and safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
        or safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
    score = score + clamp((dmi - 1) * 20, 0, 20)
    score = score + clamp(sign * c.momentumATR * 12, 0, 20)
    score = score + clamp((c.adx - Cfg.MinimumTrendADX) * 1.2, 0, 15)
    if setup == "BREAKOUT" then score = score + 15
    elseif setup == "EMA_PULLBACK" then score = score + 12
    elseif setup == "CONTINUATION" then score = score + 10
    elseif setup == "RANGE" then score = score + 8 end
    local trigger = Rt.cleanTrigger(side, 0, 0.5)
    if trigger then score = score + 8 end
    if Cfg.CleanUseVWAPQuality and setup ~= "RANGE" then
        local directionalVWAP = sign * (tonumber(c.vwapDistATR) or 0)
        if directionalVWAP >= 0 then
            score = score + Cfg.CleanVWAPAlignedBonus
            if setup == "EMA_PULLBACK"
                and directionalVWAP >= (Cfg.CleanPullbackVWAPPenaltyATR or 15.0) then
                score = score - (Cfg.CleanPullbackVWAPPenaltyScore or 8.0)
            end
        else
            score = score - Cfg.CleanVWAPOpposedPenalty
        end
    end
    if Cfg.UseHTF and Rt.htfStatus == "READY" then
        if Rt.htfTrend == (side == "B" and 1 or -1) then score = score + 6
        elseif Rt.htfTrend == (side == "B" and -1 or 1) then score = score - 6 end
    end
    local st = tostring(Context.marketStructureBias or "UNKNOWN")
    if st == (side == "B" and "BULLISH" or "BEARISH") then score = score + 6
    elseif st == (side == "B" and "BEARISH" or "BULLISH") then score = score - 6 end
    return clamp(score, 0, 100)
end

-- Dedicated clean-engine VWAP fade setup. This intentionally reuses the
-- existing VWAP Fade Module permissions and geometry so enabling the clean
-- entry engine no longer makes the module unreachable.
function Rt.cleanVWAPFade(side)
    if side ~= "B" and side ~= "S" then return false end
    local ok, detail = vwapFadeStatus(side)
    if not ok then return false, nil, nil, detail end
    local regime = side == "B" and "REVERSAL_BULL" or "REVERSAL_BEAR"
    local setup = side == "B" and "VWAP_FADE_LONG" or "VWAP_FADE_SHORT"
    return true, regime, setup, detail
end

-- Mean-reversion score for clean VWAP fades. Trend EMA/DMI alignment is not
-- rewarded here because the trade is deliberately counter-extension. A fade
-- that exactly satisfies the configured module thresholds clears the default
-- clean score; stronger stretch/exhaustion, lower ADX and a turn improve it.
function Rt.cleanVWAPFadeScore(side)
    local c = Context
    local dist = tonumber(c.vwapDistATR) or 0
    local absDist = abs(dist)
    local minStretch = max(tonumber(Cfg.VWAPFadeMinATR) or 2.0, 0.5)
    local rsi = tonumber(c.rsi) or 50
    local rsiThreshold = side == "B" and (tonumber(Cfg.VWAPFadeRSILow) or 30)
        or (tonumber(Cfg.VWAPFadeRSIHigh) or 70)
    local adx = tonumber(c.adx) or 0
    local maxAdx = tonumber(Cfg.VWAPFadeMaxADX) or 0

    local score = 25
    local stretchDepth = clamp((absDist - minStretch) / minStretch, 0, 1)
    score = score + 10 + 10 * stretchDepth

    local rsiDepth = side == "B"
        and clamp((rsiThreshold - rsi) / 20.0, 0, 1)
        or clamp((rsi - rsiThreshold) / 20.0, 0, 1)
    score = score + 10 + 10 * rsiDepth

    local rejected = (side == "B" and c.rejectionBull) or (side == "S" and c.rejectionBear)
    score = score + (rejected and 15 or 10)

    if maxAdx > 0 then
        score = score + clamp((maxAdx - adx) / maxAdx * 10.0, 0, 10)
    else
        score = score + 5
    end

    local turning = side == "B"
        and (tonumber(c.momentumATR) or 0) > -0.15 and (tonumber(c.momentumATR) or 0) < 0.85
        or side == "S" and (tonumber(c.momentumATR) or 0) < 0.15 and (tonumber(c.momentumATR) or 0) > -0.85
    if turning then score = score + 5 end

    local structure = tostring(c.marketStructureBias or "UNKNOWN")
    if structure == (side == "B" and "BULLISH" or "BEARISH") then score = score + 5 end
    return clamp(score, 0, 100)
end

function Rt.cleanChoose(p)
    local state = Rt.cleanState()
    local upgraded = Rt.cleanPullbackUpgradeEnabled()
    local directionWhy, pullbackWhy = nil, nil
    if upgraded then
        Rt.cleanPullbackDetails = {}
        local longOK, longPhase, longWhy = Rt.cleanPullbackDirection("B")
        local shortOK, shortPhase, shortWhy = Rt.cleanPullbackDirection("S")
        if not longOK then Rt.cleanPullbackPending.B=nil; Rt.cleanPullbackDetails.B={status="WAIT",reason=longWhy} end
        if not shortOK then Rt.cleanPullbackPending.S=nil; Rt.cleanPullbackDetails.S={status="WAIT",reason=shortWhy} end
        if longOK and Cfg.AllowedSide ~= "Sell" then
            state = longPhase == "EARLY" and "EARLY_TREND_UP"
                or (Context.momentumATR > 0 and "TREND_UP" or "TREND_UP_PULLBACK")
        elseif shortOK and Cfg.AllowedSide ~= "Buy" then
            state = shortPhase == "EARLY" and "EARLY_TREND_DOWN"
                or (Context.momentumATR < 0 and "TREND_DOWN" or "TREND_DOWN_PULLBACK")
        else
            directionWhy = "PULLBACK_DIRECTION | LONG=" .. tostring(longWhy) .. " SHORT=" .. tostring(shortWhy)
        end
    end
    -- Apply profile/state permissions before the setup hierarchy. Keeping this
    -- in CLEAN selection leaves Legacy V2's advisory Smart State policy intact.
    local allowTrend, allowBreakout, allowRange = tradeTypesEffective()
    local normalSides = {}
    local normalReason = nil

    if state == "TREND_UP" or state == "TREND_UP_PULLBACK" or state == "EARLY_TREND_UP" then
        normalSides = {"B"}
    elseif state == "TREND_DOWN" or state == "TREND_DOWN_PULLBACK" or state == "EARLY_TREND_DOWN" then
        normalSides = {"S"}
    elseif state == "RANGE" then
        normalSides = {"B", "S"}
    else
        local c = Context
        local longRatio = safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
        local shortRatio = safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
        if c.adx >= Cfg.CleanTransitionADX and c.momentumATR >= Cfg.CleanTransitionMomentumATR
            and ((not Cfg.CleanRequireFullEMAStack) or Rt.cleanEMAStack("B"))
            and longRatio >= Cfg.CleanTransitionDMIRatio then
            normalSides = {"B"}
        elseif c.adx >= Cfg.CleanTransitionADX and c.momentumATR <= -Cfg.CleanTransitionMomentumATR
            and ((not Cfg.CleanRequireFullEMAStack) or Rt.cleanEMAStack("S"))
            and shortRatio >= Cfg.CleanTransitionDMIRatio then
            normalSides = {"S"}
        else
            -- Do not return yet: a genuine VWAP fade is a deliberate clean
            -- mean-reversion exception to directional TRANSITION coherence.
            normalReason = "transition has no coherent direction"
        end
    end

    local function sideAllowed(side)
        return not (side == "B" and Cfg.AllowedSide == "Sell")
            and not (side == "S" and Cfg.AllowedSide == "Buy")
    end

    local best = nil
    local function consider(side, ok, regime, setup, why, score, required, setupAnchor)
        if not ok or not sideAllowed(side) then return end
        local candidate = {
            side=side, regime=regime, setup=setup, why=why,
            score=score, required=required, setupAnchor=setupAnchor
        }
        if upgraded and setup == "EMA_PULLBACK" then
            local d = Rt.cleanPullbackDetails[side]
            candidate.upgradedPullback = true
            candidate.phase = d ~= nil and d.phase or nil
            candidate.pullbackTouchDate = d ~= nil and d.event ~= nil and d.event.date or nil
            candidate.pullbackScoreParts = d ~= nil and d.scoreParts or nil
            -- Entry geometry quality must not silently increase adaptive size.
            candidate.riskScore, candidate.riskRequired = Rt.cleanScore(side, setup), Cfg.CleanMinEntryScore
        end
        local qualified = candidate.score >= candidate.required
        local bestQualified = best ~= nil and best.score >= best.required
        if best == nil or (qualified and not bestQualified)
            or (qualified == bestQualified and candidate.score > best.score) then best = candidate end
    end

    -- Fifth clean setup: evaluate both VWAP-fade directions independently of
    -- the trend EMA stack. vwapFadeStatus() still enforces both user switches,
    -- TradeTypeProfile/Smart-State permission, stretch, RSI, rejection and ADX.
    for _, side in ipairs({"B", "S"}) do
        if not Cfg.OnlyEMAPullbacks and sideAllowed(side) then
            local ok, regime, setup, why = Rt.cleanVWAPFade(side)
            if ok then
                consider(side, true, regime, setup, why,
                    Rt.cleanVWAPFadeScore(side), Cfg.CleanMinEntryScore)
            end
        end
    end

    local filtered = {}
    for _, side in ipairs(normalSides) do
        if sideAllowed(side) then filtered[#filtered + 1] = side end
    end
    normalSides = filtered

    for _, side in ipairs(normalSides) do
        local ok, regime, setup, why, setupAnchor
        if state == "RANGE" then
            -- Dedicated mean-reversion branch: do not let a compressed RANGE
            -- state be re-labeled as a trend pullback merely because ADX is in
            -- the 15-18 overlap zone.
            if allowRange and not Cfg.OnlyEMAPullbacks then
                ok, regime, setup, why = Rt.cleanRange(side, state, p)
            end
        else
            -- Trend hierarchy: good pullback location first, then fresh breakout,
            -- then a continuation only after a recent EMA re-base.
            if allowTrend then ok, regime, setup, why = Rt.cleanPullback(side) end
            if upgraded and not ok and why ~= nil then pullbackWhy = why end
            if ok and upgraded and setup == "EMA_PULLBACK" then
                local d = Rt.cleanPullbackDetails[side]
                setupAnchor = d ~= nil and d.event ~= nil and d.event.anchor or nil
            end
            if not ok and allowBreakout and not Cfg.OnlyEMAPullbacks then
                ok, regime, setup, why, setupAnchor = Rt.cleanBreakout(side, p)
            end
            if not ok and allowTrend and not Cfg.OnlyEMAPullbacks then
                ok, regime, setup, why = Rt.cleanContinuation(side, state, p)
            end
        end
        if ok then
            local score = setup == "RANGE" and Rt.cleanRangeScore(side, p)
                or (upgraded and setup == "EMA_PULLBACK" and Rt.cleanPullbackScore(side) or Rt.cleanScore(side, setup))
            local required = setup == "RANGE" and Cfg.CleanRangeMinScore
                or (upgraded and setup == "EMA_PULLBACK" and Cfg.CleanPullbackMinScore or Cfg.CleanMinEntryScore)
            consider(side, true, regime, setup, why, score, required, setupAnchor)
        end
    end

    if best == nil then
        if upgraded and (pullbackWhy ~= nil or directionWhy ~= nil) then
            return nil, state, pullbackWhy or directionWhy
        end
        if Cfg.OnlyEMAPullbacks and state ~= "TREND_UP" and state ~= "TREND_UP_PULLBACK"
            and state ~= "TREND_DOWN" and state ~= "TREND_DOWN_PULLBACK" then
            return nil, state, "EMA_PULLBACK_ONLY: waiting for aligned trend state and EMA9/EMA20 pullback"
        end
        if #normalSides == 0 and normalReason == nil then
            return nil, state, "allowed-side setting blocks coherent direction"
        end
        if Cfg.CleanRequireFullEMAStack and state ~= "RANGE" and normalReason == nil then
            local bullStack, bearStack = Rt.cleanEMAStack("B"), Rt.cleanEMAStack("S")
            if not bullStack and not bearStack then
                return nil, state, "full EMA stack not aligned (require 9>20>50 LONG or 9<20>50 SHORT)"
            end
        end
        if state == "TREND_UP_PULLBACK" then
            return nil, state, "bull trend pullback; waiting for EMA9/EMA20 bullish reclaim trigger"
        elseif state == "TREND_DOWN_PULLBACK" then
            return nil, state, "bear trend pullback; waiting for EMA9/EMA20 bearish reclaim trigger"
        elseif state == "TREND_UP" then
            return nil, state, "bull direction valid; location not ready (wait pullback/re-base or fresh breakout)"
        elseif state == "TREND_DOWN" then
            return nil, state, "bear direction valid; location not ready (wait pullback/re-base or fresh breakout)"
        elseif normalReason ~= nil then
            return nil, state, normalReason
        end
        return nil, state, "no clean setup trigger passed"
    end

    local required = best.required or Cfg.CleanMinEntryScore
    if best.score < required then
        return nil, state, string.format("%s %.1f < %.1f",
            best.upgradedPullback and "PULLBACK_QUALITY_SCORE" or "clean score", best.score, required)
    end
    return best, state, nil
end

-- =========================
-- Legacy V2 simplified evidence engine
-- =========================
-- V2 deliberately separates four market states from five entry setup families.
-- It reuses the already-tested setup geometry, but does NOT reuse the old
-- probability/regime candidate arbitration or its adaptive score/edge maze.
function Rt.legacyV2State()
    local c = Context
    local atr = tonumber(c.atr) or 0
    if atr <= 0 then return "TRANSITION" end
    local longRatio = safeDiv(c.plusDirection, max(c.minusDirection, 0.1), 0)
    local shortRatio = safeDiv(c.minusDirection, max(c.plusDirection, 0.1), 0)
    local up = c.emaFast > c.emaMed and c.adx >= Cfg.MinimumTrendADX
        and longRatio >= Cfg.CleanMinDMIRatio
    local down = c.emaFast < c.emaMed and c.adx >= Cfg.MinimumTrendADX
        and shortRatio >= Cfg.CleanMinDMIRatio
    if up and not down then return "TREND_UP" end
    if down and not up then return "TREND_DOWN" end
    local compression = safeDiv(max(c.emaFast, max(c.emaMed, c.emaSlow))
        - min(c.emaFast, min(c.emaMed, c.emaSlow)), atr, math.huge)
    if c.adx < Cfg.CleanRangeMaxADX
        and compression <= Cfg.CleanRangeMaxMACompressionATR
        and abs(c.momentumATR) <= Cfg.CleanRangeMaxMomentumATR then
        return "RANGE"
    end
    return "TRANSITION"
end

function Rt.legacyV2FamilyAllowed(setup)
    local profile = Cfg.TradeTypeProfile or "MANUAL"
    local family = Rt.setupFamily(nil, setup)
    if profile == "TREND_FOCUS" then
        if family == "RANGE" or family == "VWAP_FADE" or family == "REVERSAL" then return false end
    elseif profile == "FADE_FOCUS" then
        if family == "EMA_PULLBACK" or family == "CONTINUATION" or family == "BREAKOUT" then return false end
    end
    if family == "EMA_PULLBACK" or family == "CONTINUATION" then return Cfg.AllowTrendTrades end
    if family == "BREAKOUT" then return Cfg.AllowBreakoutTrades end
    if family == "RANGE" then return Cfg.AllowRangeTrades and Cfg.CleanAllowRange end
    if family == "VWAP_FADE" then return Cfg.UseVWAPFade end
    return false
end

function Rt.legacyV2FadeStatus(side)
    if not Rt.legacyV2FamilyAllowed(side == "B" and "VWAP_FADE_LONG" or "VWAP_FADE_SHORT") then
        return false, "VWAP fade disabled by Legacy V2 family/profile switch"
    end
    local c = Context
    local dist = tonumber(c.vwapDistATR) or 0
    local rsi = tonumber(c.rsi) or 50
    local adx = tonumber(c.adx) or 0
    local minStretch = Cfg.VWAPFadeMinATR or 2.0
    local maxAdx = Cfg.VWAPFadeMaxADX or 0
    if maxAdx > 0 and adx > maxAdx then
        return false, string.format("VWAP fade blocked: ADX %.1f > %.1f", adx, maxAdx)
    end
    if side == "B" then
        local stretch = dist <= -minStretch
        local rsiOK = rsi <= (Cfg.VWAPFadeRSILow or 30)
        local reject = (not Cfg.VWAPFadeRequireRejection) or c.rejectionBull
        return stretch and rsiOK and reject,
            string.format("VWAP_FADE_LONG stretch=%.2f RSI=%.1f rejection=%s", dist, rsi, yn(reject))
    end
    local stretch = dist >= minStretch
    local rsiOK = rsi >= (Cfg.VWAPFadeRSIHigh or 70)
    local reject = (not Cfg.VWAPFadeRequireRejection) or c.rejectionBear
    return stretch and rsiOK and reject,
        string.format("VWAP_FADE_SHORT stretch=%.2f RSI=%.1f rejection=%s", dist, rsi, yn(reject))
end

function Rt.legacyV2SmartStateDelta(side)
    if Cfg.LegacyV2SmartStatePolicy == "OFF" or not Cfg.UseSmartMarketState then return 0, "off" end
    local st = tostring(Rt.smartState or "TRANSITION")
    local conf = clamp((tonumber(Rt.smartStateConfidence) or 0) / 100.0, 0, 1)
    local bonus = (Cfg.LegacyV2SmartStateBonus or 5.0) * conf
    local bull = st == "BULL_TREND" or st == "BULL_BREAKOUT" or st == "BULL_REVERSAL" or st == "FADE_LONG_SETUP"
    local bear = st == "BEAR_TREND" or st == "BEAR_BREAKOUT" or st == "BEAR_REVERSAL" or st == "FADE_SHORT_SETUP"
    if side == "B" and bull or side == "S" and bear then return bonus, "aligned " .. st end
    if side == "B" and bear or side == "S" and bull then return -bonus, "opposed " .. st end
    return 0, "neutral " .. st
end

function Rt.legacyV2Required(setup)
    local family = Rt.setupFamily(nil, setup)
    if family == "RANGE" then return Cfg.LegacyV2RangeMinEvidence end
    if family == "VWAP_FADE" or family == "REVERSAL" then return Cfg.LegacyV2FadeMinEvidence end
    return Cfg.LegacyV2TrendMinEvidence
end

function Rt.legacyV2EvaluateCandidate(side, regime, setup, why, setupAnchor)
    local parts = nil
    parts = probabilityScoreBreakdown(side, regime)
    local base = clamp((parts.direction or 0) + (parts.structure or 0) + (parts.location or 0)
        + (parts.htf or 0) + (parts.momentum or 0) + (parts.environment or 0), 0, 100)
    local stateDelta, stateNote = Rt.legacyV2SmartStateDelta(side)
    local score = clamp(base + stateDelta, 0, 100)
    local required = Rt.legacyV2Required(setup)
    local blockers = {}
    local family = Rt.setupFamily(regime, setup)

    if not Rt.legacyV2FamilyAllowed(setup) then
        blockers[#blockers+1] = "setup family disabled"
    end
    if score < required then
        blockers[#blockers+1] = string.format("evidence %.1f < %.1f", score, required)
    end
    if family == "EMA_PULLBACK" or family == "CONTINUATION" or family == "BREAKOUT" then
        if (parts.direction or 0) < Cfg.LegacyV2MinDirection then
            blockers[#blockers+1] = string.format("direction %.1f < %.1f", parts.direction or 0, Cfg.LegacyV2MinDirection)
        end
        if (parts.structure or 0) < Cfg.LegacyV2MinStructure then
            blockers[#blockers+1] = string.format("structure %.1f < %.1f", parts.structure or 0, Cfg.LegacyV2MinStructure)
        end
        if (parts.location or 0) < Cfg.LegacyV2MinLocation then
            blockers[#blockers+1] = string.format("location %.1f < %.1f", parts.location or 0, Cfg.LegacyV2MinLocation)
        end
        if (parts.momentum or 0) < Cfg.LegacyV2MinMomentum then
            blockers[#blockers+1] = string.format("momentum %.1f < %.1f", parts.momentum or 0, Cfg.LegacyV2MinMomentum)
        end
    elseif family == "RANGE" then
        if (parts.location or 0) < Cfg.LegacyV2MinLocation then
            blockers[#blockers+1] = string.format("range location %.1f < %.1f", parts.location or 0, Cfg.LegacyV2MinLocation)
        end
        if (parts.momentum or 0) < Cfg.LegacyV2MinMomentum then
            blockers[#blockers+1] = string.format("range trigger %.1f < %.1f", parts.momentum or 0, Cfg.LegacyV2MinMomentum)
        end
    elseif family == "VWAP_FADE" or family == "REVERSAL" then
        local fadeLocationMin = max(Cfg.LegacyV2MinLocation, 12.0)
        if (parts.location or 0) < fadeLocationMin then
            blockers[#blockers+1] = string.format("fade location %.1f < %.1f", parts.location or 0, fadeLocationMin)
        end
        if (parts.momentum or 0) < Cfg.LegacyV2MinMomentum then
            blockers[#blockers+1] = string.format("fade trigger %.1f < %.1f", parts.momentum or 0, Cfg.LegacyV2MinMomentum)
        end
    end
    if Cfg.LegacyV2SmartStatePolicy == "STRICT" and Cfg.UseSmartMarketState
        and (tonumber(Rt.smartStateConfidence) or 0) < Cfg.LegacyV2StrictMinConfidence then
        blockers[#blockers+1] = string.format("smart state confidence %.0f < %.0f",
            tonumber(Rt.smartStateConfidence) or 0, Cfg.LegacyV2StrictMinConfidence)
    end

    return {
        side=side, regime=regime, setup=setup, why=why, score=score, required=required,
        setupAnchor=setupAnchor,
        parts=parts, stateDelta=stateDelta, stateNote=stateNote, v2Blockers=blockers,
        v2Qualified=#blockers == 0
    }
end

function Rt.legacyV2Choose(p)
    local state = Rt.legacyV2State()
    local candidates = {}
    local function sideAllowed(side)
        return not (side == "B" and Cfg.AllowedSide == "Sell")
            and not (side == "S" and Cfg.AllowedSide == "Buy")
    end
    local function add(side, ok, regime, setup, why, setupAnchor)
        if ok and sideAllowed(side) and Rt.legacyV2FamilyAllowed(setup) then
            candidates[#candidates+1] = Rt.legacyV2EvaluateCandidate(side, regime, setup, why, setupAnchor)
        end
    end

    -- VWAP fade is an explicit setup family, not a market regime.
    for _, side in ipairs({"B", "S"}) do
        if not Cfg.OnlyEMAPullbacks and sideAllowed(side) then
            local ok, detail = Rt.legacyV2FadeStatus(side)
            if ok then
                add(side, true, side == "B" and "REVERSAL_BULL" or "REVERSAL_BEAR",
                    side == "B" and "VWAP_FADE_LONG" or "VWAP_FADE_SHORT", detail)
            end
        end
    end

    if state == "RANGE" then
        if not Cfg.OnlyEMAPullbacks then
            for _, side in ipairs({"B", "S"}) do
                local ok, regime, setup, why = Rt.cleanRange(side, "RANGE", p)
                add(side, ok, regime, setup, why)
            end
        end
    elseif state == "TREND_UP" or state == "TREND_DOWN" then
        local side = state == "TREND_UP" and "B" or "S"
        local ok, regime, setup, why, setupAnchor = Rt.cleanPullback(side, true)
        if not ok and not Cfg.OnlyEMAPullbacks then ok, regime, setup, why, setupAnchor = Rt.cleanBreakout(side, p) end
        if not ok and not Cfg.OnlyEMAPullbacks then ok, regime, setup, why = Rt.cleanContinuation(side, state, p) end
        add(side, ok, regime, setup, why, setupAnchor)
    else
        -- TRANSITION may still produce a fresh breakout, but no generic
        -- trend/reversal regime is fabricated just to obtain a candidate.
        if not Cfg.OnlyEMAPullbacks then
            for _, side in ipairs({"B", "S"}) do
                local ok, regime, setup, why, setupAnchor = Rt.cleanBreakout(side, p)
                add(side, ok, regime, setup, why, setupAnchor)
            end
        end
    end

    if #candidates == 0 then return nil, state, "no Legacy V2 setup trigger passed" end
    local best = candidates[1]
    for i = 2, #candidates do
        local c = candidates[i]
        if (c.v2Qualified and not best.v2Qualified)
            or (c.v2Qualified == best.v2Qualified and c.score > best.score) then
            best = c
        end
    end
    if not best.v2Qualified then
        return best, state, table.concat(best.v2Blockers, " || ")
    end
    return best, state, nil
end

function Rt.legacyV2Confirm(candidate)
    if candidate == nil then return false, nil, "no clean candidate to confirm" end
    local confirm = Rt.legacyV2EvaluateCandidate(candidate.side, candidate.regime, candidate.setup,
        candidate.why, candidate.setupAnchor)
    if confirm.v2Qualified then return true, confirm, nil end
    return false, confirm, table.concat(confirm.v2Blockers, " || ")
end

function Rt.legacyV2Diagnostic(p, state, candidate, action, extraBlockers)
    local b = {}
    if candidate ~= nil and candidate.v2Blockers ~= nil then
        for i = 1, #candidate.v2Blockers do b[#b+1] = candidate.v2Blockers[i] end
    end
    if extraBlockers ~= nil then
        for i = 1, #extraBlockers do b[#b+1] = extraBlockers[i] end
    end
    local parts = candidate and candidate.parts or {}
    local text = string.format(
        "%s | LEGACY_V2 | TF=%s BAR=%d | STATE=%s | SIDE=%s | SETUP=%s | EVIDENCE=%.1f/%.1f | BUCKET D=%.1f S=%.1f L=%.1f H=%.1f M=%.1f E=%.1f | STATE_DELTA=%+.1f[%s] | ACTION=%s | BLOCK=%s",
        STRATEGY_NAME, tostring(Cfg.TF), p, tostring(state),
        candidate and (candidate.side == "B" and "LONG" or "SHORT") or "NONE",
        candidate and tostring(candidate.setup) or "NONE",
        candidate and candidate.score or 0, candidate and candidate.required or Cfg.LegacyV2TrendMinEvidence,
        parts.direction or 0, parts.structure or 0, parts.location or 0, parts.htf or 0,
        parts.momentum or 0, parts.environment or 0,
        candidate and (candidate.stateDelta or 0) or 0, candidate and tostring(candidate.stateNote or "none") or "none",
        tostring(action), #b > 0 and table.concat(b, " || ") or "none")
    writeCSVLog("LEGACY_V2", text, closedBarEndDate(p) or Rt.Source:date(p))
    if Cfg.ShowDebug or Cfg.ShowCleanDiagnostics then emitTerminalDiagnostic(text) end
    return text
end

function Rt.evaluateCandidateML(candidate)
    if candidate == nil then return nil, nil end
    local ok, ml = pcall(function()
        return SmartAI.evaluateEntry(candidate.side, candidate.regime, candidate.score,
            candidate.required, candidate.setup)
    end)
    if not ok then
        return {status=Cfg.MLMode == "FILTER" and "ERROR_BLOCK" or "ERROR_OBSERVE",
            probability=nil, features=nil, block=Cfg.MLMode == "FILTER", samples=0},
            "SmartAI evaluation failed: " .. tostring(ml)
    end
    if ml ~= nil and ml.block then
        return ml, string.format("SmartAI FILTER blocked%s",
            ml.probability ~= nil and string.format(" p=%.3f", ml.probability) or "")
    end
    return ml, nil
end

-- Compatibility name retained for callers and diagnostics from older builds.
function Rt.legacyV2EvaluateML(candidate)
    return Rt.evaluateCandidateML(candidate)
end

function Rt.cleanDiagnostic(p, state, candidate, blockers, action)
    local c = Context
    local side = candidate and (candidate.side == "B" and "LONG" or "SHORT") or "NONE"
    local setup = candidate and candidate.setup or "NONE"
    local score = candidate and candidate.score or 0
    local required = candidate and (candidate.required or Cfg.CleanMinEntryScore) or Cfg.CleanMinEntryScore
    local block = (#blockers > 0) and table.concat(blockers, " || ") or "none"
    local htf = not Cfg.UseHTF and "DISABLED" or (Rt.htfStatus == "READY" and (Rt.htfTrend == 1 and "BULLISH" or Rt.htfTrend == -1 and "BEARISH" or "NEUTRAL") or tostring(Rt.htfStatus))
    local vwapDist = tonumber(c.vwapDistATR) or 0
    local vwapState = "NEUTRAL"
    local inferredSide = candidate and candidate.side or nil
    if candidate == nil then
        if state == "TREND_UP" or state == "TREND_UP_PULLBACK" or state == "EARLY_TREND_UP" then inferredSide = "B"
        elseif state == "TREND_DOWN" or state == "TREND_DOWN_PULLBACK" or state == "EARLY_TREND_DOWN" then inferredSide = "S"
        else inferredSide = nil end
    end
    local hardVWAPMax = tonumber(Cfg.MaxEntryVWAPDistanceATR) or 0
    local hardVWAPStatus = Cfg.BlockEntriesFarFromVWAP
        and (abs(vwapDist) > hardVWAPMax and "BLOCK" or "OK") or "OFF"
    local pullbackVWAPMax = tonumber(Cfg.CleanPullbackMaxVWAPStretchATR) or 20.0
    local pullbackVWAPLine
    if inferredSide ~= nil then
        local directional = (inferredSide == "B" and 1 or -1) * vwapDist
        pullbackVWAPLine = string.format("side=%s dist=%+.2fATR max=%.2fATR status=%s",
            inferredSide == "B" and "LONG" or "SHORT", directional, pullbackVWAPMax,
            directional > pullbackVWAPMax and "BLOCK" or "OK")
    else
        pullbackVWAPLine = string.format("LONG=%+.2f/%.2fATR:%s SHORT=%+.2f/%.2fATR:%s",
            vwapDist, pullbackVWAPMax, vwapDist > pullbackVWAPMax and "BLOCK" or "OK",
            -vwapDist, pullbackVWAPMax, -vwapDist > pullbackVWAPMax and "BLOCK" or "OK")
    end
    local penaltyState = not Cfg.CleanUseVWAPQuality and "OFF"
        or Cfg.CleanPullbackVWAPPenaltyNormalized and "NORMALIZED"
        or Cfg.CleanPullbackVWAPPenaltyATR < pullbackVWAPMax and "ACTIVE" or "NO_ZONE"
    pullbackVWAPLine = pullbackVWAPLine .. string.format(" penaltyStart=%.2fATR scorePenalty=%.0f state=%s",
        tonumber(Cfg.CleanPullbackVWAPPenaltyATR) or 0,
        tonumber(Cfg.CleanPullbackVWAPPenaltyScore) or 0, penaltyState)
    if candidate ~= nil and Cfg.CleanUseVWAPQuality then
        local sign = candidate.side == "B" and 1 or -1
        local directionalVWAP = sign * vwapDist
        if candidate.setup == "VWAP_FADE_LONG" or candidate.setup == "VWAP_FADE_SHORT" then
            local meanRevOK = candidate.side == "B" and vwapDist < 0 or candidate.side == "S" and vwapDist > 0
            vwapState = meanRevOK
                and (candidate.side == "B" and "FADE_LONG_OK" or "FADE_SHORT_OK")
                or "FADE_WEAK"
        elseif candidate.setup == "RANGE" then
            if Cfg.CleanRangeUseVWAPMeanReversion then
                local meanRevOK = candidate.side == "B" and vwapDist < 0 or candidate.side == "S" and vwapDist > 0
                vwapState = meanRevOK and "MEANREV_OK" or "MEANREV_WEAK"
            else
                vwapState = "RANGE_VWAP_DISABLED"
            end
        elseif directionalVWAP >= 0 then vwapState = "ALIGNED" else vwapState = "OPPOSED" end
        local limit = candidate.setup == "CONTINUATION" and Cfg.CleanContinuationMaxVWAPStretchATR
            or candidate.setup == "BREAKOUT" and Cfg.CleanBreakoutMaxVWAPStretchATR
            or candidate.setup == "EMA_PULLBACK" and Cfg.CleanPullbackMaxVWAPStretchATR or nil
        if limit ~= nil and directionalVWAP > limit then vwapState = "EXTENDED" end
    elseif not Cfg.CleanUseVWAPQuality then
        vwapState = "DISABLED"
    end
    if Cfg.BlockEntriesFarFromVWAP then
        local hardMax = tonumber(Cfg.MaxEntryVWAPDistanceATR) or 0
        if abs(vwapDist) > hardMax then
            vwapState = string.format("TOO_FAR>%.2fATR", hardMax)
        elseif not Cfg.CleanUseVWAPQuality then
            vwapState = string.format("HARD_FILTER_OK<=%.2fATR", hardMax)
        end
    end
    local stack = Rt.cleanEMAStack("B") and "BULL 9>20>50" or Rt.cleanEMAStack("S") and "BEAR 9<20<50" or "MIXED/NOT ALIGNED"
    local msg = string.format("%s | TF=%s | BAR %d\nSTATE | %s | SIDE=%s | SETUP=%s\nSCORE | %.0f/%.0f\nEMA | %.2f / %.2f / %.2f | STACK=%s\nVWAP | %.2f | DIST=%+.2fATR | %s\nVWAP_HARD_CAP | dist=%+.2fATR max=%.2fATR status=%s\nVWAP_PULLBACK_CAP | %s\nTREND | ADX=%.1f | DI+=%.1f DI-=%.1f | MOM=%+.2fATR | HTF=%s\nACTION | %s\nBLOCK | %s",
        STRATEGY_NAME, tostring(Cfg.TF), p, tostring(state), side, setup, score, required,
        c.emaFast, c.emaMed, c.emaSlow, stack, tonumber(c.vwap) or 0, vwapDist, vwapState,
        vwapDist, hardVWAPMax, hardVWAPStatus, pullbackVWAPLine,
        c.adx, c.plusDirection, c.minusDirection, c.momentumATR, htf, tostring(action), block)
    if Rt.cleanPullbackUpgradeEnabled() then
        local d = inferredSide ~= nil and Rt.cleanPullbackDetails[inferredSide] or nil
        msg = msg .. "\nPULLBACK_UPGRADE | mode=UPGRADED phase=" .. tostring(d ~= nil and d.phase or "NONE")
            .. " status=" .. tostring(d ~= nil and d.status or "WAIT")
            .. " event=" .. tostring(d ~= nil and d.event ~= nil and d.event.date or "NONE")
            .. " reason=" .. tostring(d ~= nil and d.reason or block)
        if d ~= nil and d.score ~= nil then
            msg = msg .. string.format(" quality=%.1f/%.1f | %s",d.score,Cfg.CleanPullbackMinScore,tostring(d.scoreParts))
        end
        if candidate ~= nil and candidate.riskScore ~= nil then
            msg = msg .. string.format(" | sizingQuality=%.1f/%.1f",candidate.riskScore,candidate.riskRequired)
        end
    end
    writeCSVLog("BAR_CLEAN_V91", msg, closedBarEndDate(p) or Rt.Source:date(p))
    if Cfg.ShowCleanDiagnostics then emitTerminalDiagnostic(msg) end
end

-- Cross-engine setup identity. Engine-specific keys are retained for detailed
-- diagnostics, while this GLOBAL fingerprint prevents CLEAN/LEGACY switching
-- from re-trading the same structural event under a different namespace.
function Rt.setupFamily(regime, setup)
    local text = tostring(setup or regime or "UNKNOWN")
    if string.find(text, "VWAP_FADE", 1, true) then return "VWAP_FADE" end
    if string.find(text, "BREAKOUT", 1, true) then return "BREAKOUT" end
    if string.find(text, "PULLBACK", 1, true) then return "EMA_PULLBACK" end
    if string.find(text, "CONTINUATION", 1, true) then return "CONTINUATION" end
    if text == "RANGE" or tostring(regime) == "CHOPPY_RANGE" then return "RANGE" end
    if string.sub(tostring(regime or ""), 1, 8) == "REVERSAL" then return "REVERSAL" end
    return text
end

function Rt.globalSetupFingerprint(side, regime, setup, anchor)
    if side ~= "B" and side ~= "S" then return nil end
    if not validNumber(anchor) then return nil end
    return table.concat({"GLOBAL", tostring(side), Rt.setupFamily(regime, setup),
        string.format("%.10f", anchor)}, ":")
end

function Rt.markSetupUsed(setupKey, globalKey, p)
    if setupKey ~= nil then Rt.usedSetupKeys[setupKey] = p end
    if globalKey ~= nil then Rt.usedSetupKeys[globalKey] = p end
end

-- Clean-engine setup identity. This connects the v9 entry engine to the
-- original SetupResetBars/usedSetupKeys persistence and async-rejection logic.
-- The structural anchor identifies the setup, while the CLEAN namespace keeps
-- these keys distinct from legacy v8 setup identities.
function Rt.cleanBuildSetupIdentity(side, regime, setup, p, detectedAnchor, pullbackTouchDate)
    local anchor
    if setup == "BREAKOUT" then
        -- Use the exact level that admitted this candidate. Compatibility callers
        -- without a captured anchor must use the same breakout window, not SwingPeriod.
        anchor = detectedAnchor
        if not validNumber(anchor) then
            local hi, lo = Rt.cleanPriorExtremes(p, Cfg.CleanBreakoutLookback)
            anchor = side == "B" and hi or lo
        end
        if not validNumber(anchor) then return nil, nil end
    elseif setup == "EMA_PULLBACK" or setup == "CONTINUATION" then
        anchor = side == "B" and Context.swingLow or Context.swingHigh
        -- Retain the shared structural price anchor for cross-engine locks.
        -- The separate PB date below identifies the individual upgraded touch.
    elseif setup == "RANGE" then
        anchor = side == "B" and Context.swingLow or Context.swingHigh
    elseif setup == "VWAP_FADE_LONG" or setup == "VWAP_FADE_SHORT" then
        -- A fade is already entered on the opposite side of VWAP. Using VWAP as
        -- its management anchor would make REVERSAL_BULL/BEAR fail immediately.
        -- Anchor instead to the rejection/signal candle extreme; a later close
        -- through that extreme is the structural-failure exit.
        anchor = side == "B" and Context.low or Context.high
        if not validNumber(anchor) then
            anchor = side == "B" and Context.swingLow or Context.swingHigh
        end
    else
        anchor = Context.vwap
    end
    if not validNumber(anchor) then anchor = Context.vwap end
    if not validNumber(anchor) then return nil, nil end
    if setup == "EMA_PULLBACK" and validNumber(pullbackTouchDate) then
        return table.concat({"CLEAN", tostring(regime), tostring(side), "PB",
            string.format("%.10f", pullbackTouchDate)}, ":"), anchor
    end
    local key = table.concat({"CLEAN", tostring(regime), tostring(side), tostring(setup),
        string.format("%.10f", anchor)}, ":")
    return key, anchor
end

-- Original-v8-style pre-order plan, expressed with clean-engine terminology.
-- This is emitted only after direction/location/setup/risk sizing all pass and
-- immediately before marketOrder(), so it reflects the order we actually intend
-- to submit (subject only to the final live-spread/order preflight inside marketOrder).
function Rt.stopDetailData(regime, finalStopDistance, spread)
    local pip = sourcePipSize()
    local atr = tonumber(Context.atr) or 0
    if not validNumber(pip) or pip <= 0 or not validNumber(atr) or atr <= 0 then return nil end

    local widenedATR, _, mult, volAdj = Rt.widenedATRStop(regime)
    local baseATRStop = atr * mult
    local atrFloor = (tonumber(Cfg.MinStopATR) or 0) * atr
    local pointFloor = (tonumber(Cfg.MinStopPips) or 0) * pip
    local sp = tonumber(spread) or 0
    local spreadFloor = (tonumber(Cfg.StopSpreadMultiple) or 0) * sp * pip
    local fixedStop = (tonumber(Cfg.Stop) or 0) * pip
    local policy = Cfg.SetStop and tostring(Cfg.FixedStopVolatilityPolicy or "FIXED_WITH_FLOORS") or "ADAPTIVE"
    local driver, driverValue
    if Cfg.SetStop and policy == "FIXED_WITH_FLOORS" then
        driver, driverValue = "FIXED_STOP", fixedStop
    elseif Cfg.SetStop and policy == "FIXED_WITH_VOLATILITY" and fixedStop >= widenedATR then
        driver, driverValue = "FIXED_STOP", fixedStop
    else
        driver = volAdj > 1.000001 and "WIDENED_ATR" or "ATR_BASE"
        driverValue = widenedATR
    end
    if atrFloor > driverValue + 1e-12 then driver, driverValue = "ATR_FLOOR", atrFloor end
    if pointFloor > driverValue + 1e-12 then driver, driverValue = "POINT_FLOOR", pointFloor end
    if spreadFloor > driverValue + 1e-12 then driver, driverValue = "SPREAD_FLOOR", spreadFloor end

    return {
        pip=pip, atr=atr, atrPct=Rt.volatilityPercentile(), volState=Rt.volatilityState(),
        volRisk=Rt.volatilityRiskMultiplier(), mult=mult, baseATR=baseATRStop,
        volAdj=volAdj, widenedATR=widenedATR, atrFloor=atrFloor,
        pointFloor=pointFloor, spread=sp, spreadFloor=spreadFloor,
        fixedStop=fixedStop, policy=policy, finalStop=tonumber(finalStopDistance) or 0,
        driver=driver
    }
end

local function cleanStopDetailText(regime, finalStopDistance, spread)
    local d = Rt.stopDetailData(regime, finalStopDistance, spread)
    if d == nil then return "STOP_DETAIL | unavailable" end
    return string.format(
        "STOP_DETAIL | ATR=%.2f atrPct=%.2f volState=%s volRisk=%.2f ATRmult=%.2f baseATR=%.2f volAdj=%.2f widenedATR=%.2f ATRfloor=%.2f pointFloor=%.2f spread=%.2f spreadFloor=%.2f fixedStop=%.2f mode=%s FINAL=%.2f DRIVER=%s",
        d.atr / d.pip, d.atrPct, d.volState, d.volRisk, d.mult, d.baseATR / d.pip,
        d.volAdj, d.widenedATR / d.pip, d.atrFloor / d.pip, d.pointFloor / d.pip,
        d.spread, d.spreadFloor / d.pip, d.fixedStop / d.pip, d.policy,
        d.finalStop / d.pip, d.driver)
end

function Rt.riskFitData(stopDistance, units)
    if not Rt.moneyGuardEnabled() then
        return {guarded=false, selectedUnits=tonumber(units) or 0, riskAffordable=nil}
    end
    local perLot = Rt.riskCashPerLot(stopDistance)
    local b = Rt.moneyBudget or {}
    local hardBudget = tonumber(b.hardAllowed) or tonumber(b.allowed) or 0
    local softBudget = tonumber(b.softAllowed) or tonumber(b.allowed) or 0
    local smartScale = tonumber(b.smartScale) or tonumber(Rt.lastRiskScale) or 1
    local budget = Cfg.SizingMode == "FixedLots" and hardBudget or softBudget
    local budgetType = Cfg.SizingMode == "FixedLots" and "HARD" or "SMART"
    local affordableLots = validNumber(perLot) and perLot > 0 and max(0, budget / perLot) or 0
    local affordableUnits = 0
    if validNumber(Rt.BaseSize) and Rt.BaseSize > 0 then
        affordableUnits = roundDownToBase(min(affordableLots, tonumber(Cfg.MaxLots) or affordableLots) * Rt.BaseSize)
        affordableUnits = capUnitsToExposure(affordableUnits)
    end
    local requestedLots = Cfg.SizingMode == "FixedLots" and min(tonumber(Cfg.Amount) or 0, tonumber(Cfg.MaxLots) or 0) or nil
    local requestedRisk = requestedLots ~= nil and validNumber(perLot) and perLot * requestedLots or nil
    local equity = getAccountEquity()
    local requiredRiskPct = requestedRisk ~= nil and validNumber(equity) and equity > 0
        and requestedRisk / equity * 100 or nil
    local riskAffordable
    if Cfg.SizingMode == "FixedLots" then
        riskAffordable = requestedRisk ~= nil and requestedRisk <= hardBudget + 1e-9
            and (tonumber(units) or 0) >= (tonumber(Rt.BaseSize) or math.huge)
    else
        riskAffordable = affordableUnits >= (tonumber(Rt.BaseSize) or math.huge)
    end
    return {
        guarded=true, perLot=perLot, budget=budget, budgetType=budgetType,
        hardBudget=hardBudget, softBudget=softBudget, smartScale=smartScale,
        affordableLots=affordableLots, affordableUnits=affordableUnits,
        selectedUnits=tonumber(units) or 0, requestedLots=requestedLots,
        requestedRisk=requestedRisk, requiredRiskPct=requiredRiskPct,
        riskAffordable=riskAffordable
    }
end

function Rt.cleanRiskFitText(stopDistance, units)
    local f = Rt.riskFitData(stopDistance, units)
    if not f.guarded then
        return string.format("RISK_FIT | mode=%s guard=OFF selectedUnits=%d riskAffordable=UNGUARDED",
            tostring(Cfg.SizingMode), f.selectedUnits)
    end
    return string.format(
        "RISK_FIT | mode=%s budget=%.2f budgetType=%s hardBudget=%.2f softBudget=%.2f smartScale=%.2f riskPerLot=%s requestedLots=%s requestedRisk=%s requiredRiskPct=%s affordableLots=%.2f affordableUnits=%d selectedUnits=%d riskAffordable=%s reason=%s",
        tostring(Cfg.SizingMode), f.budget, tostring(f.budgetType),
        f.hardBudget, f.softBudget, f.smartScale,
        validNumber(f.perLot) and string.format("%.2f", f.perLot) or "NA",
        f.requestedLots ~= nil and string.format("%.2f", f.requestedLots) or "ADAPTIVE",
        f.requestedRisk ~= nil and string.format("%.2f", f.requestedRisk) or "ADAPTIVE",
        f.requiredRiskPct ~= nil and string.format("%.2f%%", f.requiredRiskPct) or "NA",
        f.affordableLots, f.affordableUnits, f.selectedUnits,
        f.riskAffordable and "Y" or "N", tostring(Rt.lastSizingReason or "OK"))
end

function Rt.riskBlockLabel(stopDistance, units)
    local f = Rt.riskFitData(stopDistance, units)
    if not f.guarded then return "SIZE_UNAVAILABLE" end
    if Cfg.SizingMode == "FixedLots" then
        if f.requestedRisk ~= nil and f.requestedRisk > f.hardBudget + 1e-9 then
            return "HARD_RISK_BUDGET_EXCEEDED"
        end
        return "FIXED_SIZE_UNAVAILABLE"
    end
    return "RISK_UNAFFORDABLE"
end

function Rt.cleanOrderPlan(p, state, candidate, units, stopDistance, targetDistance, spread)
    local plannedStopPips = stopDistance / sourcePipSize()
    local plannedTargetPips = targetDistance / sourcePipSize()
    local orderEquity = getAccountEquity() or 0
    local riskBudgetText = "MANUAL_FIXED_LOTS: monetary sizing guard OFF"
    if Rt.moneyGuardEnabled() then
        local riskBudget, budgetType = Rt.selectedRiskBudget()
        riskBudgetText = string.format("%.2f[%s] hard=%.2f soft=%.2f scale=%.2f[%s] riskQuality=%.1f/%.1f",
            riskBudget, budgetType,
            Rt.moneyBudget ~= nil and (tonumber(Rt.moneyBudget.hardAllowed) or 0) or 0,
            Rt.moneyBudget ~= nil and (tonumber(Rt.moneyBudget.softAllowed) or 0) or 0,
            tonumber(Rt.lastRiskScale) or 1.0, tostring(Rt.lastRiskScaleNote or "1.0"),
            candidate.riskScore or candidate.score,
            candidate.riskRequired or candidate.required or Cfg.CleanMinEntryScore)
    end
    local text = string.format(
        "%s | ORDER_PLAN side=%s state=%s setup=%s sizing=%s equity=%.2f riskBudget=%s pipValue=%.6f pipSource=%s units=%d exposureAfter=%.0f/%.0f stop=%.2fp target=%.2fp RR=%.2f",
        STRATEGY_NAME, candidate.side, tostring(state), tostring(candidate.setup),
        Cfg.SizingMode, orderEquity, riskBudgetText, tonumber(Rt.EffectivePipValuePerBaseUnit) or 0, tostring(Rt.PipValueSource or "UNRESOLVED"),
        units, currentStrategyUnits() + units, Cfg.MaxTotalUnits,
        plannedStopPips, plannedTargetPips, safeDiv(targetDistance, stopDistance, 0))
    local stopText = cleanStopDetailText(candidate.regime, stopDistance, spread)
    local riskText = Rt.cleanRiskFitText(stopDistance, units)
    writeCSVLog("ORDER_PLAN_CLEAN_V92", text, closedBarEndDate(p) or Rt.Source:date(p))
    writeCSVLog("STOP_DETAIL", stopText, closedBarEndDate(p) or Rt.Source:date(p))
    writeCSVLog("RISK_FIT", riskText, closedBarEndDate(p) or Rt.Source:date(p))
    local rangeText = nil
    if candidate.regime == "CHOPPY_RANGE" then
        local _, _, diagnostic = Rt.rangeGeometryStatus(candidate.side, p, stopDistance, targetDistance)
        rangeText = diagnostic
        writeCSVLog("RANGE_GEOMETRY", rangeText, closedBarEndDate(p) or Rt.Source:date(p))
    end
    if Cfg.ShowCleanDiagnostics then
        local terminalText = text .. "\n" .. stopText .. "\n" .. riskText
        if rangeText ~= nil then terminalText = terminalText .. "\n" .. rangeText end
        emitTerminalDiagnostic(terminalText)
    end
end

function Rt.emitStopPreflight(p, side, regime, plannedStop, plannedTarget, plannedUnits, finalStop, finalTarget, finalUnits, liveSpread)
    local pip = sourcePipSize()
    local d = Rt.stopDetailData(regime, finalStop, liveSpread)
    local driver = d ~= nil and d.driver or "NA"
    local text = string.format(
        "STOP_PREFLIGHT | side=%s plannedSL=%.2f plannedTP=%.2f liveSpread=%.2f submittedSL=%.2f submittedTP=%.2f plannedUnits=%d resizedUnits=%d stopChanged=%s sizeChanged=%s DRIVER=%s",
        side == "B" and "BUY" or "SELL", plannedStop / pip, plannedTarget / pip, liveSpread,
        finalStop / pip, finalTarget / pip, tonumber(plannedUnits) or 0, tonumber(finalUnits) or 0,
        abs(finalStop - plannedStop) > pip * 0.001 and "Y" or "N",
        tonumber(finalUnits) ~= tonumber(plannedUnits) and "Y" or "N", driver)
    writeCSVLog("STOP_PREFLIGHT", text, closedBarEndDate(p) or Rt.Source:date(p))
    if Cfg.ShowCleanDiagnostics or Cfg.ShowDebug then emitTerminalDiagnostic(text) end
    return text
end

function Rt.cleanOrderSubmitted(p, state, candidate, units, slPips, tpPips, setupKey, requestId)
    local status = Cfg.AllowTrade and "ORDER_SUBMITTED" or "SIGNAL_ONLY"
    local mlText = " SmartAI=OFF"
    if candidate.ml ~= nil then
        local probabilityText = validNumber(candidate.ml.probability)
            and string.format(" p=%.1f%%", candidate.ml.probability * 100.0) or ""
        mlText = string.format(" SmartAI=%s%s n=%d features=%s",
            tostring(candidate.ml.status or "UNKNOWN"), probabilityText,
            tonumber(candidate.ml.samples) or 0,
            candidate.ml.features ~= nil and "Y" or "N")
    end
    local text = string.format(
        "%s | %s side=%s regime=%s entryType=%s cleanScore=%.1f/%.1f state=%s units=%d SL=%.1fp TP=%.1fp request=%s setup=%s%s",
        STRATEGY_NAME, status, candidate.side == "B" and "BUY" or "SELL", candidate.regime,
        tostring(candidate.setup), candidate.score, candidate.required or Cfg.CleanMinEntryScore,
        tostring(state), units, slPips, tpPips, tostring(requestId or "PENDING/UNKNOWN"),
        displaySetupKey(setupKey), mlText)
    writeCSVLog(Cfg.AllowTrade and "ORDER_SUBMITTED_CLEAN_V93" or "SIGNAL_ONLY_CLEAN_V93",
        text, closedBarEndDate(p) or Rt.Source:date(p))
    if Cfg.ShowCleanDiagnostics then
        emitTerminalDiagnostic(text)
    elseif Cfg.ShowAlerts then
        alert(text)
    end
end

function Rt.entryQuality(candidate, p, stopDistance, spreadPipsNow)
    local c = Context
    local side, setup = candidate.side, tostring(candidate.setup)
    local trendFamily = setup == "EMA_PULLBACK" or setup == "CONTINUATION"
    local checks, fails = {}, {}
    local atr = tonumber(c.atr) or 0
    local function add(name, ok, detail)
        checks[#checks + 1] = string.format("%s=%s(%s)", name, ok and "OK" or "FAIL", detail)
        if not ok then fails[#fails + 1] = name end
    end

    if atr > 0 and validNumber(tonumber(c.open)) and validNumber(tonumber(c.close)) then
        local sign = side == "B" and 1 or -1
        local body = sign * (c.close - c.open) / atr
        local range = max((c.high or 0) - (c.low or 0), 1e-9)
        local loc = clamp((c.close - c.low) / range, 0, 1)
        local dirLoc = side == "B" and loc or (1 - loc)
        if trendFamily then
            add("TRIGGER_BODY", body >= Cfg.EntryMinBodyATR,
                string.format("%.2fATR>=%.2f", body, Cfg.EntryMinBodyATR))
            add("CLOSE_LOC", dirLoc >= Cfg.EntryMinCloseLoc,
                string.format("%.2f>=%.2f", dirLoc, Cfg.EntryMinCloseLoc))
        end
        if (trendFamily or setup == "BREAKOUT") and Cfg.EntryMaxBodyATR > 0 then
            add("NOT_EXHAUSTED", body <= Cfg.EntryMaxBodyATR,
                string.format("%.2fATR<=%.2f", body, Cfg.EntryMaxBodyATR))
        end
    end

    if trendFamily then
        if Cfg.EntryRequireBreakPriorBar then
            local ph, pl = Rt.Source.high[p - 1], Rt.Source.low[p - 1]
            if validNumber(ph) and validNumber(pl) then
                local broke = (side == "B" and c.close > ph) or (side == "S" and c.close < pl)
                add("BREAKS_PRIOR_BAR", broke, broke and "yes" or "no")
            end
        end
        if Cfg.EntryMinRoomATR > 0 and atr > 0 then
            local hi, lo = Rt.cleanPriorExtremes(p, Cfg.EntryRoomLookback)
            local room = side == "B" and (hi - c.close) or (c.close - lo)
            local roomATR = max(0, room) / atr
            add("ROOM", roomATR >= Cfg.EntryMinRoomATR,
                string.format("%.2fATR>=%.2f", roomATR, Cfg.EntryMinRoomATR))
        end
    end

    if Cfg.EntryMaxSpreadStopRatio > 0 and validNumber(stopDistance) and stopDistance > 0 then
        local spreadPrice = (tonumber(spreadPipsNow) or 0) * sourcePipSize()
        local ratio = spreadPrice / stopDistance
        add("SPREAD_COST", ratio <= Cfg.EntryMaxSpreadStopRatio,
            string.format("%.2f<=%.2f", ratio, Cfg.EntryMaxSpreadStopRatio))
    end

    local rsi = tonumber(c.rsi)
    if trendFamily or setup == "BREAKOUT" then
        if rsi ~= nil and side == "B" and Cfg.EntryMaxRSILong < 100 then
            add("RSI_NOT_EXTREME", rsi <= Cfg.EntryMaxRSILong,
                string.format("%.0f<=%.0f", rsi, Cfg.EntryMaxRSILong))
        elseif rsi ~= nil and side == "S" and Cfg.EntryMinRSIShort > 0 then
            add("RSI_NOT_EXTREME", rsi >= Cfg.EntryMinRSIShort,
                string.format("%.0f>=%.0f", rsi, Cfg.EntryMinRSIShort))
        end
        if Cfg.EntryMinEfficiency > 0 and validNumber(tonumber(c.efficiency)) then
            add("EFFICIENCY", c.efficiency >= Cfg.EntryMinEfficiency,
                string.format("%.2f>=%.2f", c.efficiency, Cfg.EntryMinEfficiency))
        end
    end

    local ll = Rt.lastLoss
    local barsSinceLoss = ll ~= nil and validNumber(ll.period) and p - ll.period or nil
    if Cfg.EntryFastLossLockBars > 0 and ll ~= nil and ll.side == side
        and validNumber(ll.period) and ll.bars <= Cfg.EntryFastLossBars
        and validNumber(barsSinceLoss) and barsSinceLoss >= 0
        and barsSinceLoss < Cfg.EntryFastLossLockBars then
        add("FAST_LOSS_LOCK", false,
            string.format("%d/%d bars since fast %s loss", barsSinceLoss,
                Cfg.EntryFastLossLockBars, side == "B" and "long" or "short"))
    end

    local text = string.format("%s | ENTRY_QUALITY mode=%s side=%s setup=%s result=%s fails=%s | %s",
        STRATEGY_NAME, tostring(Cfg.EntryQualityMode), side == "B" and "LONG" or "SHORT", setup,
        #fails == 0 and "PASS" or "FAIL", #fails > 0 and table.concat(fails, ",") or "none",
        table.concat(checks, " "))
    return #fails == 0, fails, text
end

function Rt.entryQualityGate(candidate, p, stopDistance, sp)
    if Cfg.EntryQualityMode == "OFF" or candidate == nil then return true, nil end
    local ok, pass, fails, text = pcall(Rt.entryQuality, candidate, p, stopDistance, sp)
    if not ok then
        debug("ENTRY_QUALITY error (ignored, entry not blocked): " .. tostring(pass))
        return true, nil
    end
    writeCSVLog("ENTRY_QUALITY", text, closedBarEndDate(p) or Rt.Source:date(p))
    if Cfg.ShowCleanDiagnostics and not pass then emitTerminalDiagnostic(text) end
    if not pass and Cfg.EntryQualityMode == "ENFORCE" then
        return false, "entry quality: " .. table.concat(fails, ",")
    end
    return true, nil
end

function Rt.cleanProcessEntry(p, globalBlockers, globalPassed, sp, cooldownBars, cooldownOK, cooldownSource)
    local candidate, state, reason = Rt.cleanChoose(p)
    local blockers = {}
    for i = 1, #globalBlockers do blockers[#blockers+1] = globalBlockers[i] end
    if Cfg.ExecutionQualityMode == "FILTER" and Rt.executionQuality ~= nil and not Rt.executionQuality.ok then
        blockers[#blockers+1] = Rt.executionQualityText()
    end
    if candidate == nil then
        blockers[#blockers+1] = reason or "no clean candidate"
    else
        if Cfg.EntryEngineMode == "HYBRID_CONFIRM" then
            local confirmed, legacyConfirm, confirmReason = Rt.legacyV2Confirm(candidate)
            Rt.legacyV2Diagnostic(p, "CONFIRM:" .. tostring(state), legacyConfirm,
                confirmed and "CONFIRM_PASS" or "CONFIRM_BLOCK")
            if not confirmed then
                blockers[#blockers+1] = "Legacy V2 confirmation: " .. tostring(confirmReason)
            end
        end
        -- Candidate-side position policy must live in the clean pipeline because
        -- the v9 clean path returns before the legacy evidence engine. Enforce it
        -- before stop sizing, position sizing, setup locking and ORDER_PLAN.
        if Cfg.OneTradePerDirection and ownTradesCount(candidate.side) >= 1 then
            blockers[#blockers+1] = candidate.side == "B" and "one-long limit" or "one-short limit"
        end

        if Cfg.UseHTF then
            -- Clean-engine HTF policy gate. The v9 clean path returns before the
            -- legacy evidence engine, so HTF hard policies must be enforced here
            -- before sizing and before ORDER_PLAN/order submission.
            local htf = htfDiagnostic(candidate.side)
            local htfDataBad = string.sub(htf, 1, 5) == "STALE"
                or string.sub(htf, 1, 7) == "NO_DATA"
            local htfOpposed = htf == "OPPOSED_BEARISH" or htf == "OPPOSED_BULLISH"
            if Cfg.ProbabilityRequireHTFData and htfDataBad then
                blockers[#blockers+1] = "HTF data integrity=" .. htf
            elseif htf == "NEUTRAL_BLOCKED" then
                blockers[#blockers+1] = "HTF neutral entries disabled"
            elseif htfOpposed and Cfg.HTFOppositionMode == "BLOCK" then
                blockers[#blockers+1] = "HTF confirmed opposition blocked (mode=BLOCK): " .. htf
            end
        end
    end
    if #blockers > 0 then
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
        return
    end
    -- CLEAN is the default engine and must use the same Smart AI decision and
    -- immutable entry feature snapshot as LEGACY_V1/V2. OBSERVE records features
    -- for later learning; FILTER may veto only after its configured warm-up.
    local mlDecision, mlBlock = Rt.evaluateCandidateML(candidate)
    candidate.ml = mlDecision
    if mlBlock ~= nil then
        blockers[#blockers+1] = mlBlock
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
        return
    end
    local tradeRegime = candidate.regime
    local adaptiveStopDistance = calculateAdaptiveStop(tradeRegime)
    local stopDistance = adaptiveStopDistance
    local targetDistance = calculateAdaptiveTarget(tradeRegime, stopDistance)
    stopDistance, targetDistance = Rt.orderDistances(tradeRegime, stopDistance, targetDistance, sp)
    if stopDistance == nil then
        blockers[#blockers+1] = "invalid stop/target geometry"
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
        return
    end
    local qualityOK, qualityReason = Rt.entryQualityGate(candidate, p, stopDistance, sp)
    if not qualityOK then
        blockers[#blockers+1] = qualityReason
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
        return
    end
    local riskScore = candidate.riskScore or candidate.score
    local riskRequired = candidate.riskRequired or candidate.required or Cfg.CleanMinEntryScore
    local units = calculatePositionSize(stopDistance, tradeRegime, riskScore, riskRequired)
    local riskFitText = Rt.cleanRiskFitText(stopDistance, units)
    if units < Rt.BaseSize then
        writeCSVLog("RISK_FIT", riskFitText, closedBarEndDate(p) or Rt.Source:date(p))
        if Cfg.ShowCleanDiagnostics then emitTerminalDiagnostic(riskFitText) end
        blockers[#blockers+1] = Rt.riskBlockLabel(stopDistance, units) .. " | " .. tostring(Rt.lastSizingReason or "position size below broker minimum")
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
        return
    end

    local geometryOK, geometryReason = Rt.stopGeometryStatus(stopDistance)
    if not geometryOK then
        writeCSVLog("STOP_DETAIL", cleanStopDetailText(tradeRegime, stopDistance, sp), closedBarEndDate(p) or Rt.Source:date(p))
        writeCSVLog("RISK_FIT", riskFitText, closedBarEndDate(p) or Rt.Source:date(p))
        blockers[#blockers+1] = geometryReason
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
        return
    end

    if tradeRegime == "CHOPPY_RANGE" then
        local rangeOK, rangeReason, rangeText = Rt.rangeGeometryStatus(candidate.side, p, stopDistance, targetDistance)
        if not rangeOK then
            writeCSVLog("RANGE_GEOMETRY", rangeText, closedBarEndDate(p) or Rt.Source:date(p))
            writeCSVLog("RISK_FIT", riskFitText, closedBarEndDate(p) or Rt.Source:date(p))
            if Cfg.ShowCleanDiagnostics then emitTerminalDiagnostic(rangeText .. "\n" .. riskFitText) end
            blockers[#blockers+1] = rangeReason
            Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
            return
        end
    end

    local setupKey, setupAnchor = Rt.cleanBuildSetupIdentity(candidate.side, tradeRegime, candidate.setup, p,
        candidate.setupAnchor, candidate.pullbackTouchDate)
    if setupKey == nil then
        blockers[#blockers+1] = "clean setup identity unavailable"
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
        return
    end
    local globalSetupKey = Rt.globalSetupFingerprint(candidate.side, tradeRegime, candidate.setup, setupAnchor)
    local usedKey = Rt.usedSetupKeys[setupKey] ~= nil and setupKey
        or (globalSetupKey ~= nil and Rt.usedSetupKeys[globalSetupKey] ~= nil and globalSetupKey or nil)
    if usedKey ~= nil then
        local usedPeriod = Rt.usedSetupKeys[usedKey]
        local age = validNumber(usedPeriod) and (p - usedPeriod) or 0
        local expiry = Cfg.SetupResetBars
        if string.find(tostring(usedKey), ":PB:", 1, true) then
            expiry = max(expiry, max((Cfg.PullbackMaxAgeBars or 5)+1,
                (Cfg.CleanPullbackRetestLookbackBars or 0)+1))
        end
        blockers[#blockers+1] = string.format("clean setup already traded across entry engines; reset in %d bars",
            max(0, expiry - age))
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
        return
    end

    Rt.cleanOrderPlan(p, state, candidate, units, stopDistance, targetDistance, sp)

    local opened, slPips, tpPips, actualUnits, requestId = marketOrder(candidate.side, units, stopDistance, targetDistance, p,
        setupKey, setupAnchor, mlDecision, candidate.score, candidate.required or Cfg.CleanMinEntryScore,
        tradeRegime, riskScore, riskRequired, candidate.setup,
        Cfg.EntryEngineMode == "HYBRID_CONFIRM" and "HYBRID_CONFIRM" or (Cfg.EntryEngineMode == "SHADOW" and "SHADOW" or "CLEAN"))
    if opened then
        Rt.markSetupUsed(setupKey, globalSetupKey, p)
        Rt.lastEntryPeriod = p
        persistEntryRuntimeState()
        Rt.cleanDiagnostic(p, state, candidate, {}, Cfg.AllowTrade and "ORDER_SUBMITTED" or "SIGNAL_ONLY")
        Rt.cleanOrderSubmitted(p, state, candidate, actualUnits or units,
            slPips or stopDistance/sourcePipSize(),
            tpPips or targetDistance/sourcePipSize(), setupKey, requestId)
    else
        blockers[#blockers+1] = "broker/order submission failed"
        Rt.cleanDiagnostic(p, state, candidate, blockers, "WAIT")
    end
end

function Rt.legacyV2ProcessEntry(p, globalBlockers, globalPassed, sp, cooldownBars, cooldownOK, cooldownSource)
    local candidate, state, reason = Rt.legacyV2Choose(p)
    local blockers = {}
    for i = 1, #globalBlockers do blockers[#blockers+1] = globalBlockers[i] end
    if Cfg.ExecutionQualityMode == "FILTER" and Rt.executionQuality ~= nil and not Rt.executionQuality.ok then
        blockers[#blockers+1] = Rt.executionQualityText()
    end
    if candidate == nil then
        blockers[#blockers+1] = reason or "no Legacy V2 candidate"
    else
        if candidate.v2Blockers ~= nil then
            for i = 1, #candidate.v2Blockers do blockers[#blockers+1] = candidate.v2Blockers[i] end
        end
        if Cfg.OneTradePerDirection and ownTradesCount(candidate.side) >= 1 then
            blockers[#blockers+1] = candidate.side == "B" and "one-long limit" or "one-short limit"
        end
        if Cfg.UseHTF then
            local htf = htfDiagnostic(candidate.side)
            local htfDataBad = string.sub(htf, 1, 5) == "STALE"
                or string.sub(htf, 1, 7) == "NO_DATA"
            local htfOpposed = htf == "OPPOSED_BEARISH" or htf == "OPPOSED_BULLISH"
            if Cfg.ProbabilityRequireHTFData and htfDataBad then
                blockers[#blockers+1] = "HTF data integrity=" .. htf
            elseif htf == "NEUTRAL_BLOCKED" then
                blockers[#blockers+1] = "HTF neutral entries disabled"
            elseif htfOpposed and Cfg.HTFOppositionMode == "BLOCK" then
                blockers[#blockers+1] = "HTF confirmed opposition blocked (mode=BLOCK): " .. htf
            end
        end
    end
    if #blockers > 0 then
        Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
        return
    end

    local ml, mlBlock = Rt.legacyV2EvaluateML(candidate)
    if mlBlock ~= nil then
        blockers[#blockers+1] = mlBlock
        Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
        return
    end

    local tradeRegime = candidate.regime
    local stopDistance = calculateAdaptiveStop(tradeRegime)
    local targetDistance = calculateAdaptiveTarget(tradeRegime, stopDistance)
    stopDistance, targetDistance = Rt.orderDistances(tradeRegime, stopDistance, targetDistance, sp)
    if stopDistance == nil then
        blockers[#blockers+1] = "invalid stop/target geometry"
        Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
        return
    end
    local units = calculatePositionSize(stopDistance, tradeRegime, candidate.score, candidate.required)
    if units < Rt.BaseSize then
        blockers[#blockers+1] = Rt.riskBlockLabel(stopDistance, units) .. " | "
            .. tostring(Rt.lastSizingReason or "position size below broker minimum")
        Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
        return
    end
    local geometryOK, geometryReason = Rt.stopGeometryStatus(stopDistance)
    if not geometryOK then
        blockers[#blockers+1] = geometryReason
        Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
        return
    end
    if tradeRegime == "CHOPPY_RANGE" then
        local rangeOK, rangeReason, rangeText = Rt.rangeGeometryStatus(candidate.side, p, stopDistance, targetDistance)
        if not rangeOK then
            blockers[#blockers+1] = rangeReason
            writeCSVLog("RANGE_GEOMETRY", rangeText, closedBarEndDate(p) or Rt.Source:date(p))
            Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
            return
        end
    end

    local setupKey, setupAnchor = Rt.cleanBuildSetupIdentity(candidate.side, tradeRegime, candidate.setup, p,
        candidate.setupAnchor)
    if setupKey == nil then
        blockers[#blockers+1] = "Legacy V2 setup identity unavailable"
        Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
        return
    end
    local globalSetupKey = Rt.globalSetupFingerprint(candidate.side, tradeRegime, candidate.setup, setupAnchor)
    local usedKey = Rt.usedSetupKeys[setupKey] ~= nil and setupKey
        or (globalSetupKey ~= nil and Rt.usedSetupKeys[globalSetupKey] ~= nil and globalSetupKey or nil)
    if usedKey ~= nil then
        blockers[#blockers+1] = "setup already traded across entry engines: " .. displaySetupKey(usedKey)
        Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
        return
    end

    local orderText = string.format(
        "%s | LEGACY_V2 ORDER_PLAN side=%s state=%s setup=%s evidence=%.1f/%.1f units=%d stop=%.2fp target=%.2fp RR=%.2f",
        STRATEGY_NAME, candidate.side == "B" and "BUY" or "SELL", state, candidate.setup,
        candidate.score, candidate.required, units, stopDistance/sourcePipSize(), targetDistance/sourcePipSize(),
        safeDiv(targetDistance, stopDistance, 0))
    writeCSVLog("ORDER_PLAN_LEGACY_V2", orderText, closedBarEndDate(p) or Rt.Source:date(p))
    if Cfg.ShowDebug or Cfg.ShowCleanDiagnostics then emitTerminalDiagnostic(orderText) end

    local opened, slPips, tpPips, actualUnits, requestId = marketOrder(candidate.side, units,
        stopDistance, targetDistance, p, setupKey, setupAnchor, ml, candidate.score, candidate.required,
        tradeRegime, candidate.score, candidate.required, candidate.setup, "LEGACY_V2")
    if opened then
        Rt.markSetupUsed(setupKey, globalSetupKey, p)
        Rt.lastEntryPeriod = p
        persistEntryRuntimeState()
        Rt.legacyV2Diagnostic(p, state, candidate, Cfg.AllowTrade and "ORDER_SUBMITTED" or "SIGNAL_ONLY")
        local text = string.format(
            "%s | %s engine=LEGACY_V2 side=%s regime=%s setup=%s evidence=%.1f/%.1f units=%d SL=%.1fp TP=%.1fp request=%s",
            STRATEGY_NAME, Cfg.AllowTrade and "ORDER_SUBMITTED" or "SIGNAL_ONLY",
            candidate.side == "B" and "BUY" or "SELL", tradeRegime, candidate.setup,
            candidate.score, candidate.required, actualUnits or units,
            slPips or stopDistance/sourcePipSize(), tpPips or targetDistance/sourcePipSize(),
            tostring(requestId or "PENDING/UNKNOWN"))
        writeCSVLog(Cfg.AllowTrade and "ORDER_SUBMITTED_LEGACY_V2" or "SIGNAL_ONLY_LEGACY_V2",
            text, closedBarEndDate(p) or Rt.Source:date(p))
        if Cfg.ShowAlerts then alert(text) end
    else
        blockers[#blockers+1] = "broker/order submission failed"
        Rt.legacyV2Diagnostic(p, state, candidate, "WAIT", blockers)
    end
end

local function processClosedBar(p)
    Rt.processingPeriod = p
    Rt.closedQuoteCache = {}
    Rt.executionQuality = nil
    Rt.marketOutlook = nil -- do not carry a stale outlook through missing-data bars
    Rt.contextReadyForBar = false
    restoreEntryRuntimeState(p)

    -- v9.2.14: broker/account close reconciliation is independent of indicator
    -- readiness. Process it before any indicator/warm-up/OHLC early return so a
    -- real broker-confirmed close can start cooldown and reset accounting on time.
    local evaluationDate = closedBarEndDate(p) or Rt.Source:date(p)
    resetSessionStatistics(evaluationDate)
    refreshClosedTradeLosses()
    -- Reconcile confirmed rows first; only unresolved requests should reach the
    -- timeout/safety-lock logic on this bar.
    if Cfg.AllowTrade then pruneStalePendingCloses(p) end

    -- Mandatory liquidation is independent of indicator warm-up/readiness and
    -- must run before every early return in the signal engine.
    local mandatoryCloseBlocked = processMandatoryClose(p)

    -- Native indicators warm their entire history via UpdateAll on the first
    -- closed-bar callback and then advance with UpdateLast on subsequent bars.
    if not calculateIndicators(p) then
        Rt.manageProtectionOnly(p)
        debug(string.format("NO TRADE | native indicator update unavailable p=%d", p))
        return
    end

    local nativeFirst = nativeFirstPeriod() or Rt.Source:first()
    local structuralWarmup = Rt.Source:first() + max(Cfg.SwingPeriod,
        max(Cfg.MomentumPeriod, max(Cfg.BreakoutCompressionLookback, Cfg.VolumeLookback))) + 5
    local statisticalWarmup = nativeFirst + Cfg.StatsPeriod + 3
    local warmup = max(structuralWarmup, statisticalWarmup)
    if p <= warmup then
        Rt.manageProtectionOnly(p)
        debug(string.format("NO TRADE | WARMUP p=%d need>%d sourceFirst=%d", p, warmup, Rt.Source:first()))
        return
    end
    if not validNumber(Ind.atr[p]) or Ind.atr[p] <= 0 or not validNumber(Ind.rsi[p])
        or not validNumber(Ind.adx[p]) or not validNumber(Ind.vwap[p]) then
        Rt.manageProtectionOnly(p)
        debug(string.format("NO TRADE | indicator data missing p=%d ATR=%s RSI=%s ADX=%s VWAP=%s", p,tostring(Ind.atr[p]),tostring(Ind.rsi[p]),tostring(Ind.adx[p]),tostring(Ind.vwap[p])))
        return
    end

    local o, h, l, c = Rt.Source.open[p], Rt.Source.high[p], Rt.Source.low[p], Rt.Source.close[p]
    if not (validNumber(o) and validNumber(h) and validNumber(l) and validNumber(c))
        or h < max(o,c) or l > min(o,c) or h < l or Rt.copyRecoveryFrom ~= nil then
        Rt.manageProtectionOnly(p)
        debug("NO TRADE | invalid OHLC or incomplete indicator recovery")
        return
    end
    updateMarketContext(p)
    Rt.contextReadyForBar = true
    Rt.updateExecutionQuality(p)
    calculateRegimeScores()
    Rt.currentRegime = detectMarketRegime()
    Rt.currentBaseRegime = detectBaseMarketRegime()
    Rt.currentRegime = resolveLowVolatilityTrendException(Rt.currentRegime)
    globalMarketSessionAllowed(closedBarEndDate(p) or Rt.Source:date(p))
    updateLiveMarketPulse()
    updateSmartMarketState(Rt.currentRegime)
    SmartAI.updateMarketOutlook(p)
    if Cfg.WriteCSVLogFile and not Rt.csvLoggingDisabled then
        writeCSVLog("MARKET_OUTLOOK", SmartAI.marketOutlookText(), closedBarEndDate(p) or Rt.Source:date(p))
    end

    manageOpenPositions(p)
    if Cfg.AllowTrade then pruneStalePendingOpens(p) end
    pruneUsedSetupKeys(p)

    local globalBlockers, globalPassed = {}, {}
    local barDate = evaluationDate
    local _, now = getSessionTime(barDate)
    if not InRange(now, Rt.OpenTime, Rt.CloseTime, true) then
        globalBlockers[#globalBlockers+1] = "outside session"
    else
        globalPassed[#globalPassed+1] = "session"
    end

    local marketSessionAllowed, marketSession, marketSessionClock = globalMarketSessionAllowed(barDate)
    local marketSessionText = tostring(marketSession)
    if marketSessionClock ~= nil then
        local utcMinutes = math.floor(marketSessionClock * 1440 + 0.5) % 1440
        marketSessionText = string.format("%s %02d:%02d UTC", marketSessionText,
            math.floor(utcMinutes / 60), utcMinutes % 60)
    end
    if not marketSessionAllowed then
        globalBlockers[#globalBlockers+1] = "global session disabled: " .. marketSessionText
    elseif Cfg.UseGlobalSessionFilter then
        globalPassed[#globalPassed+1] = "global session " .. marketSessionText
    else
        globalPassed[#globalPassed+1] = "global session filter off (" .. marketSessionText .. ")"
    end

    local inLunch, cetClock, cetZone = isCETLunchBreak(barDate)
    if inLunch then
        local lunchText = "CET lunch break"
        if cetClock ~= nil then
            local totalMinutes = math.floor(cetClock * 1440 + 0.5) % 1440
            lunchText = string.format("CET lunch break %02d:%02d %s", math.floor(totalMinutes / 60), totalMinutes % 60, cetZone or "CET")
        end
        globalBlockers[#globalBlockers+1] = lunchText
    elseif Cfg.UseCETLunchBreak then
        globalPassed[#globalPassed+1] = "CET lunch clear"
    end

    -- Entry-only gate. This intentionally runs after manageOpenPositions(p),
    -- so a news blackout can never suspend exits or broker-stop ratcheting.
    local newsAllowed, newsText = newsFilterStatus(barDate)
    if not newsAllowed then
        globalBlockers[#globalBlockers+1] = newsText
    else
        globalPassed[#globalPassed+1] = newsText
    end
    if Cfg.AllowTrade and (not checkReady("trades") or not checkReady("orders")) then globalBlockers[#globalBlockers+1] = "trading tables not ready" else globalPassed[#globalPassed+1] = "tables ready" end

    local riskOK, riskReason = checkRiskLimits()
    if not riskOK then globalBlockers[#globalBlockers+1] = riskReason else globalPassed[#globalPassed+1] = "risk limits" end

    local sp = spreadPips(p)
    if sp > Cfg.MaxSpreadPips then globalBlockers[#globalBlockers+1] = string.format("spread %.2fp > %.2fp", sp, Cfg.MaxSpreadPips) else globalPassed[#globalPassed+1] = string.format("spread %.2fp", sp) end

    -- v9.2.17 optional universal chase protection. This is deliberately an
    -- absolute distance gate (not directional alignment): when enabled, no
    -- entry family may open if the closed-bar price is too far from VWAP.
    -- It runs before either entry engine, sizing, setup locking, and ORDER_PLAN.
    if Cfg.BlockEntriesFarFromVWAP then
        local vwapDistATR = tonumber(Context.vwapDistATR)
        local maxVWAPDistATR = tonumber(Cfg.MaxEntryVWAPDistanceATR) or 0
        if not validNumber(vwapDistATR) then
            globalBlockers[#globalBlockers+1] = "VWAP distance unavailable for hard entry filter"
        elseif abs(vwapDistATR) > maxVWAPDistATR then
            globalBlockers[#globalBlockers+1] = string.format(
                "VWAP_TOO_FAR | distance=%.2fATR max=%.2fATR", abs(vwapDistATR), maxVWAPDistATR)
        else
            globalPassed[#globalPassed+1] = string.format(
                "VWAP distance %.2f/%.2fATR", abs(vwapDistATR), maxVWAPDistATR)
        end
    end

    local cooldownPeriodBefore, cooldownSourceBefore = cooldownReferencePeriod()
    local cooldownBarsBefore = cooldownPeriodBefore ~= nil and (p - cooldownPeriodBefore) or nil
    local cooldownOKBefore = cooldownPeriodBefore == nil or cooldownBarsBefore >= Cfg.MinBarsBetweenTrades
    if not cooldownOKBefore then
        globalBlockers[#globalBlockers+1] = string.format("cooldown %d/%d bars after %s",
            cooldownBarsBefore, Cfg.MinBarsBetweenTrades, cooldownSourceBefore or "trade event")
    else
        globalPassed[#globalPassed+1] = "cooldown"
    end
    if Rt.regimeConflict then
        globalPassed[#globalPassed+1] = string.format("regime conflict retained as evidence: %s %.1f vs %s %.1f",
            tostring(Rt.regimeBestName), Rt.regimeBestScore or 0,
            tostring(Rt.regimeCompetitorName or Rt.regimeSecondName), Rt.regimeCompetitorScore or Rt.regimeSecondScore or 0)
    elseif Rt.currentRegime == "NONE" then
        globalPassed[#globalPassed+1] = "no dominant legacy regime; v7 side evidence still evaluated"
    elseif Rt.currentRegime == "LOW_VOLATILITY" or Rt.currentRegime == "HIGH_VOLATILITY" then
        globalPassed[#globalPassed+1] = tostring(Rt.currentRegime) .. " retained as environment evidence"
    end
    if mandatoryCloseBlocked then globalBlockers[#globalBlockers+1] = "mandatory close window" end

    local entryMode = Cfg.EntryEngineMode or "CLEAN"
    if entryMode == "SHADOW" then
        local shadowCandidate, shadowState, shadowReason = Rt.legacyV2Choose(p)
        local shadowExtra = {}
        if shadowCandidate == nil and shadowReason ~= nil then shadowExtra[#shadowExtra+1] = shadowReason end
        Rt.legacyV2Diagnostic(p, shadowState, shadowCandidate, "SHADOW_ONLY", shadowExtra)
        Rt.cleanProcessEntry(p, globalBlockers, globalPassed, sp, cooldownBarsBefore,
            cooldownOKBefore, cooldownSourceBefore)
        return
    elseif entryMode == "CLEAN" or entryMode == "HYBRID_CONFIRM" then
        Rt.cleanProcessEntry(p, globalBlockers, globalPassed, sp, cooldownBarsBefore,
            cooldownOKBefore, cooldownSourceBefore)
        return
    elseif entryMode == "LEGACY_V2" then
        Rt.legacyV2ProcessEntry(p, globalBlockers, globalPassed, sp, cooldownBarsBefore,
            cooldownOKBefore, cooldownSourceBefore)
        return
    end

    -- LEGACY_V1 intentionally falls through to the original probability/regime
    -- arbitration below for regression compatibility and operator A/B testing.
    if Cfg.UseSmartMarketState then
        local minConf = tonumber(Cfg.SmartStateMinConfidence) or 0
        local conf = tonumber(Rt.smartStateConfidence) or 0
        if minConf > 0 and conf < minConf then
            globalBlockers[#globalBlockers+1] = string.format(
                "smart state confidence %.0f < %.0f (%s)",
                conf, minConf, tostring(Rt.smartState or "UNKNOWN"))
        else
            globalPassed[#globalPassed+1] = string.format(
                "smart state %s conf=%.0f", tostring(Rt.smartState or "UNKNOWN"), conf)
        end
    end

    if Rt.executionQuality ~= nil then
        local qualityText = Rt.executionQualityText()
        writeCSVLog("EXECUTION_QUALITY", qualityText, evaluationDate)
        if Cfg.ExecutionQualityMode == "FILTER" and not Rt.executionQuality.ok then
            globalBlockers[#globalBlockers + 1] = qualityText
        else
            globalPassed[#globalPassed + 1] = qualityText
        end
    end

    local longInfo = makeEntryInfo("B")
    local shortInfo = makeEntryInfo("S")
    if Cfg.WriteCSVLogFile and Rt.regimeWeightAudit ~= nil then
        writeCSVLog("REGIME_WEIGHTS", Rt.regimeWeightAudit
            .. "|global=" .. tostring(Rt.currentRegime)
            .. "|long=" .. longInfo.regime .. ";score=" .. tostring(longInfo.score)
            .. ";blockers=" .. tostring(#longInfo.blockers)
            .. "|short=" .. shortInfo.regime .. ";score=" .. tostring(shortInfo.score)
            .. ";blockers=" .. tostring(#shortInfo.blockers), evaluationDate)
    end

    if #globalBlockers > 0 then
        traceFullBar(p, "NO TRADE", globalBlockers, globalPassed, longInfo, shortInfo)
        return
    end

    local longOK = #longInfo.blockers == 0
    local shortOK = #shortInfo.blockers == 0
    if not longOK and not shortOK then
        traceFullBar(p, "NO TRADE", globalBlockers, globalPassed, longInfo, shortInfo)
        return
    end

    local scoreDifference = longInfo.score - shortInfo.score
    if abs(scoreDifference) <= 0.0000001 then
        globalBlockers[#globalBlockers+1] = "LONG/SHORT evidence tie; no directional winner"
        traceFullBar(p, "NO TRADE", globalBlockers, globalPassed, longInfo, shortInfo)
        return
    end
    local leaderSide = scoreDifference > 0 and "B" or "S"
    local leader = leaderSide == "B" and longInfo or shortInfo
    -- Boolean selection must not fall through to the opposite side when false.
    local leaderOK
    if leaderSide == "B" then
        leaderOK = longOK
    else
        leaderOK = shortOK
    end
    local evidenceEdge = abs(longInfo.score - shortInfo.score)
    local edgeRequired = smartRequiredEdge(leaderSide, longInfo.htf, shortInfo.htf)
    if evidenceEdge < edgeRequired then
        globalBlockers[#globalBlockers+1] = string.format("directional evidence edge %.1f < %.1f", evidenceEdge, edgeRequired)
        traceFullBar(p, "NO TRADE", globalBlockers, globalPassed, longInfo, shortInfo)
        return
    end
    if not leaderOK then
        globalBlockers[#globalBlockers+1] = "stronger market side is blocked by a hard gate; no weaker-side substitution"
        traceFullBar(p, "NO TRADE", globalBlockers, globalPassed, longInfo, shortInfo)
        return
    end

    local side = leaderSide
    local chosen = leader
    local tradeRegime = chosen.regime
    local adaptiveStopDistance = calculateAdaptiveStop(tradeRegime)
    -- Size from the exact stop that will be submitted, including fixed-stop policy and safety floors.
    local stopDistance = adaptiveStopDistance
    local targetDistance = calculateAdaptiveTarget(tradeRegime, stopDistance)
    stopDistance, targetDistance = Rt.orderDistances(tradeRegime, stopDistance, targetDistance, sp)
    if stopDistance == nil then
        globalBlockers[#globalBlockers+1] = "invalid stop/target geometry"
        traceFullBar(p, "NO TRADE", globalBlockers, globalPassed, longInfo, shortInfo)
        return
    end
    local riskScore, riskRequired = chosen.score, chosen.required
    if Rt.moneyGuardEnabled() and Cfg.UseSmartMoneyManagement
        and Cfg.ScaleRiskByQuality and Cfg.ActivityEffectiveProfile ~= "BALANCED" then
        -- The profile can admit more setups, but must not make the same setup
        -- look stronger for sizing merely by relaxing score or pullback inputs.
        local riskParts
        riskParts, riskScore = probabilityScoreBreakdown(side, tradeRegime, true)
        riskRequired = smartRequiredScore(side, tradeRegime, chosen.htf, riskParts, true)
    end
    local units = calculatePositionSize(stopDistance, tradeRegime, riskScore, riskRequired)
    if units < Rt.BaseSize then
        globalBlockers[#globalBlockers+1] = string.format("position size %d below base unit %d: %s", units, Rt.BaseSize, tostring(Rt.lastSizingReason or "unknown"))
        traceFullBar(p, "NO TRADE", globalBlockers, globalPassed, longInfo, shortInfo)
        return
    end

    local plannedStopPips = stopDistance / sourcePipSize()
    local plannedTargetPips = targetDistance / sourcePipSize()
    local orderEquity = getAccountEquity() or 0
    local riskBudgetText = "MANUAL_FIXED_LOTS: monetary sizing guard OFF"
    if Rt.moneyGuardEnabled() then
        local riskScale, scaleNote = smartRiskScale(riskScore, riskRequired, tradeRegime)
        local riskBudget, budgetType = Rt.selectedRiskBudget()
        riskBudgetText = string.format("%.2f[%s] hard=%.2f soft=%.2f scale=%.2f[%s] riskQuality=%.1f/%.1f",
            riskBudget, budgetType,
            Rt.moneyBudget ~= nil and (tonumber(Rt.moneyBudget.hardAllowed) or 0) or 0,
            Rt.moneyBudget ~= nil and (tonumber(Rt.moneyBudget.softAllowed) or 0) or 0,
            riskScale, tostring(scaleNote), riskScore, riskRequired)
    end
    debug(string.format("ORDER_PLAN side=%s sizing=%s equity=%.2f riskBudget=%s pipValue=%.6f pipSource=%s units=%d exposureAfter=%.0f/%.0f stop=%.2fp target=%.2fp RR=%.2f",
        side, Cfg.SizingMode, orderEquity, riskBudgetText, tonumber(Rt.EffectivePipValuePerBaseUnit) or 0, tostring(Rt.PipValueSource or "UNRESOLVED"),
        units, currentStrategyUnits() + units, Cfg.MaxTotalUnits,
        plannedStopPips, plannedTargetPips, safeDiv(targetDistance,stopDistance,0)))

    local opened, actualStopPips, actualTargetPips, actualUnits, requestId = marketOrder(side, units, stopDistance, targetDistance, p,
        chosen.setupKey, chosen.setupAnchor, chosen.ml, chosen.score, chosen.required, tradeRegime, riskScore, riskRequired, chosen.entryType, "LEGACY_V1")
    if opened then
        Rt.markSetupUsed(chosen.setupKey, chosen.globalSetupKey, p)
        Rt.lastEntryPeriod = p
        persistEntryRuntimeState()
        -- Report the ACTUAL submitted SL/TP (may differ from the adaptive
        -- plan above if SetStop/SetLimit fixed-pip overrides are enabled),
        -- not the pre-override adaptive values, so the alert matches what
        -- was really sent to the broker.
        local mlText = " SmartAI=OFF"
        if chosen.ml ~= nil and chosen.ml.probability ~= nil then
            mlText = string.format(" SmartAI=%s/%.1f%%", chosen.ml.status, chosen.ml.probability * 100.0)
        elseif chosen.ml ~= nil then
            mlText = " SmartAI=" .. tostring(chosen.ml.status)
        end
        alert(string.format("%s | %s side=%s regime=%s entryType=%s probabilityEvidence=%.1f/100 edge=%.1f units=%d SL=%.1fp TP=%.1fp request=%s%s",
            STRATEGY_NAME, Cfg.AllowTrade and "ORDER_SUBMITTED" or "SIGNAL_ONLY",
            side == "B" and "BUY" or "SELL", tradeRegime, tostring(chosen.entryType or "NA"),
            chosen.score, evidenceEdge, actualUnits or units, actualStopPips or plannedStopPips,
            actualTargetPips or plannedTargetPips, tostring(requestId or "PENDING/UNKNOWN"), mlText))
        traceFullBar(p, side == "B" and "BUY" or "SELL", globalBlockers, globalPassed,
            longInfo, shortInfo, {focusSide=side, cooldownBars=cooldownBarsBefore,
                cooldownOK=cooldownOKBefore, cooldownSource=cooldownSourceBefore})
    else
        globalBlockers[#globalBlockers+1] = "broker/order submission failed"
        traceFullBar(p, "NO TRADE", globalBlockers, globalPassed, longInfo, shortInfo)
    end
end

-- =========================
-- Indicore callbacks
-- =========================
function ExtUpdate(id, source, period)
    flushPendingLogs()

    if id == Const.HTF_SOURCE_ID then
        -- helper.lua supplies the last CLOSED bar as period for bar subscriptions.
        local hp = period
        if Rt.HTFSource ~= nil and hp > Rt.HTFSource:first() then updateHTFContext(hp) end
        return
    end

    if id ~= Const.MAIN_SOURCE_ID then return end

    -- helper.lua supplies the last CLOSED bar as period; do not subtract again.
    local p = period
    if p <= Rt.Source:first() then return end
    -- The main subscription may deliver before id=2 at startup/reconnect.
    -- Recover from the newest already-loaded CLOSED HTF candle before any
    -- entry diagnostics are evaluated.
    if Cfg.UseHTF then recoverHTFContext(closedBarEndDate(p) or Rt.Source:date(p)) end
    local serial = Rt.Source:serial(p)
    if Rt.lastMainClosedSerial == serial then return end
    Rt.lastMainClosedSerial = serial

    if Cfg.WriteCSVLogFile then
        local logDate = closedBarEndDate(p) or Rt.Source:date(p)
        local logDay = getUTCDayKey(logDate)
        if Rt.csvRunId == nil then
            local timestamp = csvTimestampUTC(logDate)
            Rt.csvConfigId = csvConfigurationId()
            -- tostring(Rt) supplies a per-instance token in Indicore's Lua
            -- process. Combining it with the dated first bar and config hash
            -- keeps repeated tests in one daily file analytically separable.
            Rt.csvRunId = string.gsub(timestamp, "[^%d]", "") .. "_"
                .. stableTextHash(tostring(Rt) .. "|" .. timestamp .. "|" .. Rt.csvConfigId)
        end
        if Rt.csvStartupDay ~= logDay
            and writeCSVLog("SYSTEM", "RUN START|strategy_version=" .. STRATEGY_VERSION
                .. "|config_id=" .. tostring(Rt.csvConfigId)
                .. "|statsLookback=" .. tostring(Cfg.StatsPeriod)
                .. "|UTC_day=" .. tostring(logDay), logDate) then
            Rt.csvStartupDay = logDay
        end
    end

    processClosedBar(p)
end

function ExtAsyncOperationFinished(cookie, success, message, message1, message2)
    local openTracked = Rt.pendingOpenCookies[cookie]
    local closeTracked = Rt.pendingCloseCookies[cookie]
    local stopTracked = Rt.pendingStopEditCookies[cookie]
    if openTracked ~= nil then
        Rt.pendingOpenCookies[cookie] = nil
        if not success then
            -- The unique cookie identifies exactly which submission failed;
            -- no CSV/request-ID guess is required to clear its pending state.
            if openTracked.requestId ~= nil
                and Rt.pendingOpenRequests[openTracked.requestId] == openTracked.pending then
                Rt.pendingOpenRequests[openTracked.requestId] = nil
            elseif Rt.pendingUnknownOpen == openTracked.pending then
                Rt.pendingUnknownOpen = nil
            end
            -- Release only reservations belonging to this rejected submission;
            -- an older callback must not clear keys reserved on a later bar.
            releaseUnfilledOpenState(openTracked.pending)
            local rejectedText = string.format("%s | OPEN_REJECTED side=%s request=%s broker=%s",
                STRATEGY_NAME, openTracked.pending ~= nil and (openTracked.pending.side == "B" and "BUY" or "SELL") or "NA",
                tostring(openTracked.requestId or "UNKNOWN"), tostring(message))
            writeCSVLog("OPEN_REJECTED", rejectedText,
                openTracked.pending ~= nil and openTracked.pending.submittedAt or nil)
            alert(rejectedText)
        else
            if openTracked.pending ~= nil then openTracked.pending.accepted = true end
            local acceptedText = string.format("%s | ORDER_ACCEPTED side=%s request=%s broker=%s | awaiting TradeID/fill table",
                STRATEGY_NAME, openTracked.pending ~= nil and (openTracked.pending.side == "B" and "BUY" or "SELL") or "NA",
                tostring(openTracked.requestId or "UNKNOWN"), tostring(message))
            writeCSVLog("ORDER_ACCEPTED", acceptedText,
                openTracked.pending ~= nil and openTracked.pending.submittedAt or nil)
            if Cfg.ShowCleanDiagnostics or Cfg.ShowDebug then emitTerminalDiagnostic(acceptedText)
            elseif Cfg.ShowAlerts then alert(acceptedText) end
        end
    elseif stopTracked ~= nil then
        Rt.pendingStopEditCookies[cookie] = nil
        if Rt.pendingStopEdits[stopTracked.tradeId] == stopTracked then
            Rt.pendingStopEdits[stopTracked.tradeId] = nil
        end
        if success then
            Rt.brokerStopRates[stopTracked.tradeId] = stopTracked.requestedRate
            alert(string.format("BROKER STOP MOVED: TradeID=%s stop=%.5f",
                tostring(stopTracked.tradeId), stopTracked.requestedRate))
        else
            alert("BROKER STOP EDIT REJECTED: TradeID=" .. tostring(stopTracked.tradeId)
                .. " OrderID=" .. tostring(stopTracked.orderId) .. " | " .. tostring(message))
        end
    elseif closeTracked ~= nil then
        Rt.pendingCloseCookies[cookie] = nil
        if not success then
            -- Clear only the rejected close. Other in-flight TradeIDs/sides
            -- retain their guards and cannot be resubmitted on the next bar.
            if closeTracked.tradeId ~= nil then
                Rt.closePendingTradeIds[closeTracked.tradeId] = nil
                Rt.tradeExitReasons[closeTracked.tradeId] = nil
                Rt.tradeExitReasons[tostring(closeTracked.tradeId)] = nil
            elseif closeTracked.fifoSide ~= nil then
                Rt.fifoClosePending[closeTracked.fifoSide] = nil
            end
            alert("EXIT REJECTED: " .. tostring(message))
        else
            if closeTracked.pending ~= nil then closeTracked.pending.accepted = true end
            local closeSubject = closeTracked.tradeId ~= nil
                and ("TradeID=" .. tostring(closeTracked.tradeId))
                or ("FIFOside=" .. tostring(closeTracked.fifoSide or "NA"))
            local exitAcceptedText = string.format(
                "%s | EXIT_ACCEPTED %s broker=%s | awaiting final closed-trade row",
                STRATEGY_NAME, closeSubject, tostring(message))
            local acceptedDate = closeTracked.period ~= nil and Rt.Source ~= nil
                and Rt.Source:date(closeTracked.period) or nil
            writeCSVLog("EXIT_ACCEPTED", exitAcceptedText, acceptedDate)
            if Cfg.ShowCleanDiagnostics or Cfg.ShowDebug then emitTerminalDiagnostic(exitAcceptedText)
            elseif Cfg.ShowAlerts then alert(exitAcceptedText) end
        end
    elseif not success then
        debug("Async operation failed cookie=" .. tostring(cookie) .. " msg=" .. tostring(message))
    end
end

-- Standard FXCM strategy helper used by the uploaded TS2 strategies for ExtSubscribe callbacks.
dofile(core.app_path() .. "\\strategies\\standard\\include\\helper.lua")
