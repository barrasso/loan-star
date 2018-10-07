# LoanStar

A native mobile app written in Swift that enables one-click borrowing from anywhere in the world by tapping into Dharma's borderless, censorship resistant credit market.

## Team Member(s)
- [@barrasso](https://github.com/barrasso)

## How to use

Requirements:

- Xcode Version 10.0 (10A255)
- Cocoapods 1.5.3

Bloqboard API docs (Kovan):
- https://kovan-api.bloqboard.com/swagger/?urls.primaryName=Dharma%20Relayer%20V1

First, navigate to root directory of the the iOS project: `LoanStar/`.

Using the terminal, install the dependencies by running: `pod install`.

Open the `LoanStar.xcworkspace` using Xcode.

## Inspiration

Mobile banking is the primary way that many people in the world access financial services. Developing countries, particularly in Africa and the Middle East, rely on mobile banking to power their economies.

The main purpose of this application is to abstract all the technical web3 jargon and make it easier for end users to interact with the the Dharma Protocol, similar to a typical loan provider in web2.

## What it does

The app uses a combination of the [Bloqboard API](https://kovan-api.bloqboard.com/swagger/?urls.primaryName=Dharma%20Relayer%20V1) and [web3swift](https://github.com/matterinc/web3swift) to perform calls to the Ethereum blockchain. It allows the user to view requests to borrow, as well as filling and creating new debt orders from within the app.

## How I built it

First, I started drawing out sketches with some good old pen and paper. 
Once I settled on the views and essential features, I began to code it up using Xcode.

## Built with

- [Dharma](https://github.com/dharmaprotocol/dharma.js/blob/master/src/loan/debt_order.ts)
- [Web3Swift](https://github.com/matterinc/web3swift)
- [Bloqboard API](https://kovan-api.bloqboard.com/swagger/?urls.primaryName=Dharma%20Relayer%20V1)

## Challenges

Firstly, in order for this app to become a reality, it would be nice to include some sort of identity verification or KYC. I looked into [Wyre](https://www.sendwyre.com/docs/#issuing-kyc-token) for this.  However, I would need to use a `webview` from within my iOS application to perform the KYC process with their current API. I'll be able to do a native KYC process when Wyre's latest SDK releases which is coming soon™.

There was a bit of a mismatch in Ethereum test network support between all of the APIs and libraries that I used.
Dharma hasn't deployed their contracts to Rinkeby yet, and Bloqboard has no "liquidity" on Rinkeby. So I used Bloqboard's Kovan API to interact with the Dharma contracts. Unfortunately, in [web3swift](https://github.com/matterinc/web3swift), there is no support for Kovan, so I wasn't able to perform a call to the same contracts deployed on Kovan.

This isn't that big of a deal since Dharma can just deploy on Rinkeby so we can generate some test liquidity on that network as well. Hopefully this will also happen soon™.

## Future work and features

Some features that I'd like to include in the future:

- DAI integration (be able to choose your currency preference for principle or collateral)
- Wyre KYC - enabling under-collateralized loans
- Reminders for loan fills and payments: push notifications when your loan is filled or you need to pay
- Multi-factor authentication
