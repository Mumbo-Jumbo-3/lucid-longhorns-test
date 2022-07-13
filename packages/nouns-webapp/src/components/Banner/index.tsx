import classes from './Banner.module.css';
import Section from '../../layout/Section';
import { Col } from 'react-bootstrap';
import cows from '../../assets/cows.jpg';
import { Trans } from '@lingui/macro';

const Banner = () => {
  return (
    <Section fullWidth={false} className={classes.bannerSection}>
      <Col lg={6}>
        <div className={classes.wrapper}>
          <h1>
            <Trans>ONE LUCID LONGHORN.</Trans>
            <br />
            <Trans>EVERY 8 HOURS.</Trans>
            <br />
            <Trans>FOREVER.</Trans>
          </h1>
        </div>
      </Col>
      <Col lg={6}>
        <div className={classes.centerImage}>
          <img src={cows} alt="longhorns"/>
        </div>
      </Col>
    </Section>
  );
};

export default Banner;
