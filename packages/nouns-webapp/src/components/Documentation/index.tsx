import Section from '../../layout/Section';
import { Col } from 'react-bootstrap';
import classes from './Documentation.module.css';
import Accordion from 'react-bootstrap/Accordion';
import Link from '../Link';
import { Trans } from '@lingui/macro';

const Documentation = () => {
  const cryptopunksLink = (
    <Link
      text={<Trans>Cryptopunks</Trans>}
      url="https://www.larvalabs.com/cryptopunks"
      leavesPage={true}
    />
  );
  const nounsLink = (
    <Link
      text={<Trans>Nouns</Trans>}
      url="https://nouns.wtf"
      leavesPage={true}
    />
  );
  const corralLink = (
    <Link text={<Trans>Corral</Trans>} url="/corral" leavesPage={false} />
  );
  const publicDomainLink = (
    <Link
      text={<Trans>public domain</Trans>}
      url="https://creativecommons.org/publicdomain/zero/1.0/"
      leavesPage={true}
    />
  );
  const compoundGovLink = (
    <Link
      text={<Trans>Compound Governance</Trans>}
      url="https://compound.finance/governance"
      leavesPage={true}
    />
  );
  return (
    <Section fullWidth={false}>
      <Col lg={{ span: 10, offset: 1 }}>
        <div className={classes.headerWrapper}>
          <h1>
            <Trans>WTF?</Trans>
          </h1>
          <p className={classes.aboutText}>
            <Trans>
              Lucid Longhorns is an experimental attempt to improve the formation of digital
              communities. While projects such as {cryptopunksLink} have attempted to bootstrap
              digital community and identity, Lucid Longhorns attempt to bootstrap identity, community,
              governance, and a treasury that can be used by the community. Lucid Longhorns is a fork of {nounsLink}.
            </Trans>
          </p>
          <p className={classes.aboutText} style={{ paddingBottom: '4rem' }}>
            <Trans>
              Learn more below, or start creating Lucid Longhorns off-chain in the {corralLink}.
            </Trans>
          </p>
        </div>
        <Accordion flush>
          <Accordion.Item eventKey="0" className={classes.accordionItem}>
            <Accordion.Header className={classes.accordionHeader}>
              <Trans>Summary</Trans>
            </Accordion.Header>
            <Accordion.Body>
              <ul>
                <li>
                  <Trans>Lucid Longhorns artwork is in the {publicDomainLink}.</Trans>
                </li>
                <li>
                  <Trans>One Lucid Longhorn is auctioned off in the Cattle Royale every 8 hours, forever.</Trans>
                </li>
                <li>
                  <Trans>Settlement of one auction kicks off the next.</Trans>
                </li>
                <li>
                  <Trans>100% of auction proceeds are sent to the Lucid Co-Op.</Trans>
                </li>
                <li>
                  <Trans>All Lucid Longhorns are members of the Lucid Co-Op.</Trans>
                </li>
                <li>
                  <Trans>One Lucid Longhorn is equal to one vote.</Trans>
                </li>
                <li>
                  <Trans>The Lucid Co-Op is controlled exclusively by Lucid Longhorns via governance.</Trans>
                </li>
                <li>
                  <Trans>Artwork is generative and stored directly on-chain.</Trans>
                </li>
                <li>
                  <Trans>
                    No explicit rules exist for attribute scarcity; all Lucid Longhorns are equally rare.
                  </Trans>
                </li>
                <li>
                  <Trans>
                    Founders receive rewards in the form of Lucid Longhorns (10% of supply for first 4 years).
                  </Trans>
                </li>
              </ul>
            </Accordion.Body>
          </Accordion.Item>

          <Accordion.Item eventKey="1" className={classes.accordionItem}>
            <Accordion.Header className={classes.accordionHeader}>
              <Trans>Cattle Royale</Trans>
            </Accordion.Header>
            <Accordion.Body>
              <p className={classes.aboutText}>
                <Trans>
                  The Cattle Royale will act as a self-sufficient Lucid Longhorn generation and
                  distribution mechanism, auctioning one Lucid Longhorn every 12 hours, forever. 100% of
                  auction proceeds (ETH) are automatically deposited in the Lucid Co-Op,
                  where they are governed by Lucid Longhorn owners.
                </Trans>
              </p>

              <p className={classes.aboutText}>
                <Trans>
                  Each time an auction is settled, the settlement transaction will also cause a new
                  Lucid Longhorn to be minted and a new 8 hour auction to begin.{' '}
                </Trans>
              </p>
              <p>
                <Trans>
                  While settlement is most heavily incentivized for the winning bidder, it can be
                  triggered by anyone, allowing the system to trustlessly auction Lucid Longhorns as long as
                  Arbitrum is operational and there are interested bidders.
                </Trans>
              </p>
            </Accordion.Body>
          </Accordion.Item>
          <Accordion.Item eventKey="2" className={classes.accordionItem}>
            <Accordion.Header className={classes.accordionHeader}>
              <Trans>Lucid Co-Op</Trans>
            </Accordion.Header>
            <Accordion.Body>
              <Trans>
                The Lucid Co-Op utilizes a fork of {compoundGovLink} and is the main governing body of the
                Lucid Longhorns ecosystem. The Lucid Co-Op treasury receives 100% of ETH proceeds from daily
                Lucid Longhorn auctions. Each Lucid Longhorn is an irrevocable member of the Lucid Co-Op and entitled to one
                vote in all governance matters. Lucid Longhorn votes are non-transferable (if you sell your
                Lucid Longhorn the vote goes with it) but delegatable, which means you can assign your vote to
                someone else as long as you own your Lucid Longhorn.
              </Trans>
            </Accordion.Body>
          </Accordion.Item>
          <Accordion.Item eventKey="3" className={classes.accordionItem}>
            <Accordion.Header className={classes.accordionHeader}>
              <Trans>Governance ‘Slow Start’</Trans>
            </Accordion.Header>
            <Accordion.Body>
              <p>
                <Trans>
                  In addition to the precautions taken by Compound Governance, the founders have given
                  themselves a special veto right to ensure that no malicious proposals can be
                  passed while the Lucid Longhorn supply is low. This veto right will only be used if an
                  obviously harmful governance proposal has been passed, and is intended as a last
                  resort.
                </Trans>
              </p>
              <p>
                <Trans>
                  The founders will proveably revoke this veto right when they deem it safe to do so.
                  This decision will be based on a healthy Lucid Longhorn distribution and a community that is
                  engaged in the governance process.
                </Trans>
              </p>
            </Accordion.Body>
          </Accordion.Item>
          <Accordion.Item eventKey="4" className={classes.accordionItem}>
            <Accordion.Header className={classes.accordionHeader}>
              <Trans>Lucid Longhorn Traits</Trans>
            </Accordion.Header>
            <Accordion.Body>
              <p>
                <Trans>
                  Lucid Longhorns are generated randomly based Arbitrum block hashes. There are no 'if'
                  statements or other rules governing Lucid Longhorn trait scarcity, which makes all
                  Lucid Longhorns equally rare. As of this writing, Lucid Longhorns are made up of:
                </Trans>
              </p>
              <ul>
                <li>
                  <Trans>backgrounds (2) </Trans>
                </li>
                <li>
                  <Trans>hides (2)</Trans>
                </li>
                <li>
                  <Trans>horns (2)</Trans>
                </li>
                <li>
                  <Trans>heads (2)</Trans>
                </li>
                <li>
                  <Trans>outfits (2) </Trans>
                </li>
                <li>
                  <Trans>eyes (2) </Trans>
                </li>
                <li>
                  <Trans>snouts (2)</Trans>
                </li>
              </ul>
              <Trans>
                You can experiment with off-chain Lucid Longhorn generation at the {corralLink}.
              </Trans>
            </Accordion.Body>
          </Accordion.Item>
          <Accordion.Item eventKey="5" className={classes.accordionItem}>
            <Accordion.Header className={classes.accordionHeader}>
              <Trans>On-Chain Artwork</Trans>
            </Accordion.Header>
            <Accordion.Body>
              <p>
                <Trans>
                  Lucid Longhorns are stored directly on Arbitrum and do not utilize pointers to other
                  networks such as IPFS. This is possible because Lucid Longhorn parts are compressed and
                  stored on-chain using a custom run-length encoding (RLE), which is a form of
                  lossless compression.
                </Trans>
              </p>

              <p>
                <Trans>
                  The compressed parts are efficiently converted into a single base64 encoded SVG
                  image on-chain. To accomplish this, each part is decoded into an intermediate
                  format before being converted into a series of SVG rects using batched, on-chain
                  string concatenation. Once the entire SVG has been generated, it is base64
                  encoded.
                </Trans>
              </p>
            </Accordion.Body>
          </Accordion.Item>
          <Accordion.Item eventKey="6" className={classes.accordionItem}>
            <Accordion.Header className={classes.accordionHeader}>
              <Trans>Lucid Longhorn Seeder Contract</Trans>
            </Accordion.Header>
            <Accordion.Body>
              <p>
                <Trans>
                  The Lucid Longhorn Seeder contract is used to determine Lucid Longhorn traits during the minting
                  process. The seeder contract can be replaced to allow for future trait generation
                  algorithm upgrades. Additionally, it can be locked by the Lucid Co-Op to prevent any
                  future updates. Currently, Lucid Longhorn traits are determined using pseudo-random number
                  generation:
                </Trans>
              </p>
              <code>keccak256(abi.encodePacked(blockhash(block.number - 1), nounId))</code>
              <br />
              <br />
              <p>
                <Trans>
                  Trait generation is not truly random. Traits can be predicted when minting a Lucid Longhorn
                  on the pending block.
                </Trans>
              </p>
            </Accordion.Body>
          </Accordion.Item>
          <Accordion.Item eventKey="7" className={classes.accordionItem}>
            <Accordion.Header className={classes.accordionHeader}>
              <Trans>Founder's Reward</Trans>
            </Accordion.Header>
            <Accordion.Body>
              <p>
                <Trans>
                  The founders are the group of builders that initiated Lucid Longhorns. Here are the
                  founders:
                </Trans>
              </p>
              <ul>
                <li>
                  Texas Blockchain
                </li>
                <li>
                  yoroqui (artist)
                </li>
                <li>
                  HairyBarry (developer)
                </li>
              </ul>
              <p>
                <Trans>
                  Because 100% of Lucid Longhorn auction proceeds are sent to the Lucid Co-Op, the founders have chosen
                  to compensate themselves with Lucid Longhorns. Every 10th Lucid Longhorn for the first 4 years of the
                  project (Lucid Longhorn ids #0, #10, #20, #30 and so on) will be automatically sent to one
                  of the founders on an alternating basis.
                </Trans>
              </p>
              <p>
                <Trans>
                  The founder distributions don't interfere with the cadence of 12 hour auctions. Lucid Longhorns
                  are sent directly to the founders, and auctions continue on schedule
                  with the next available Lucid Longhorn ID.
                </Trans>
              </p>
            </Accordion.Body>
          </Accordion.Item>
        </Accordion>
      </Col>
    </Section>
  );
};
export default Documentation;
