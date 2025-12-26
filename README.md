# Iubenda Consent State – GTM Custom Variable Template (Unofficial)

This Google Tag Manager (GTM) **Custom Variable Template** retrieves the consent state for a specified **[Iubenda Purpose ID](https://www.iubenda.com/en/)**, with built-in fallback logic and customizable output transformations.

---

> Developed by **Jude Nwachukwu Onyejekwe** for [DumbData](https://dumbdata.co/)

---

## 🧠 What It Does

The variable determines the consent status (granted or denied) for a given **purpose ID** from Iubenda using:

1. **Direct Purpose Lookup**:
   If `_iub.cs.api.cs.consent.purposes` is available, the template checks the given purpose ID for consent.

2. **Regional Fallback Logic**:
   If direct lookup fails, it falls back to regional APIs:

   * `gdprApplies()`: Returns **denied** if `true`.
   * `lgpdApplies()`: Returns **denied** if `true`.
   * `ccpaApplies()`: Returns **granted** if `true` and either `consent` is `true` or `undefined`.

3. **Missing Configuration Handler**
   If no purpose-level or regional data is available but the site is detected via `_iub.csConfiguration.siteId`, it:

   * Returns a user-configured output (e.g. granted, denied, or undefined) based on a radio option.
   * Defaults to "missing consent config" (optionally transformed), if no radio is configured.

4. **Optional Value Transformation**
   If enabled, transforms `true` / `false` to:

   * `granted` or `accept`
   * `denied` or `deny`

---

## 🧰 Use Cases

* Iubenda is installed **outside GTM** (i.e., directly in the page source).
* You are working with **Basic or Advanced Consent Mode**.
* You want to create **exception triggers** based on specific consent categories.

---

## 🛠️ How to Use This Template


## 📦 Import the Template

1. Open Google Tag Manager.
2. Go to **Templates** → **Variable Templates**.
3. Click the **New** button and select **Import**.
4. Upload the `.tpl` file for this template.


## 🛠️ How to Configure the Variable

After importing the template, configure the following fields:

### 🔹 Consent Category

* **Display Name:** `Consent Category`
* **Options:** Standard Iubenda categories (for UI display only)
* **Custom Category:** If `Custom Consent Category` is selected, specify your label in **Custom Consent Category**.

### 🔹 Purpose ID

* **Display Name:** `Purpose ID`
* **Description:** The numeric ID of the consent purpose you want to check.

### 🔹 Enable Output Transformation

* **Display Name:** `Enable Output Transformation`
* **When enabled**, configure:

  * **True Output Value** → Choose between:

    * `Granted`
    * `Accept`
  * **False Output Value** → Choose between:

    * `Denied`
    * `Deny`

### 🔹 Enable Missing Consent Config Fallback

* **Display Name:** `Enable Missing Consent Config Fallback`
* **When enabled**, choose one:

  * **Missing Config Fallback Behavior**

    * `Return True Output Value`
    * `Return False Output Value`
    * `Return Undefined`
  * Then define:

    * **True Output Value (Fallback)**
    * **False Output Value (Fallback)\`**

---

## 📦 Output Examples

| Scenario                            | Output                |
| ----------------------------------- | --------------------- |
| Purpose ID is found and granted     | `granted` or `accept` |
| CCPA applies and consent is true    | `granted` or `accept` |
| GDPR applies                        | `denied` or `deny`    |
| Site ID found but config is missing | Based on fallback     |
| No config and nothing detected      | `undefined`           |

---

## ⬇️ How to Import

1. Open your GTM container.
2. Go to **Templates** > **Variable Templates**.
3. Click the **+ New** button.
4. Choose **Import Template** from the 3-dot menu (⋮).
5. Upload the provided `.tpl` file for this template.
6. Save and publish.

---

## 🤝 Author

Developed by **Jude Nwachukwu Onyejekwe**.
Feedback and contributions are welcome!
