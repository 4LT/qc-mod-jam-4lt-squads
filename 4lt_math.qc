static float MIN_ANG = -180;
static float MAX_ANG = 180;

/*
 * Approximate sqrt using Newton's method
 * Higher number of iterations = slower, but more accurate
 */
float(float x, float iterations) newton_sqrt {
    float approx, pty, ptx, slope;

    if (x < 0) {
        // error code
        return -1;
    }

    if (x < 0.5) {
        approx = 2 * x;
    } else if (x > 2) {
        approx = x/2;
    } else {
        approx = x;
    }
    
    while (iterations > 0) {
        pty = approx;
        ptx = pty * pty;
        slope = 1 / (2 * pty);

        approx = slope * (x - ptx) + pty;

        iterations-= 1;
    }

    return approx;
};

/* Find the roots to a quadratic equation
 * a - Quadratic coefficient
 * b - Linear coefficient
 * c - Constant coefficient
 * iterations - Impacts accuracy
 *
 * Roots are returned as _x and _y of vector, or 1 is returned for _z of vector
 */
vector(float a, float b, float c, float iterations) quadratic {
    float det, det_sqrt;
    vector ret_vec;

    det = b*b - 4 * a * c;
    if (det < 0) {
        return '0 0 1';
    }

    ret_vec = '0 0 0';
    det_sqrt = newton_sqrt(det, iterations);
    ret_vec_x = (-b + det_sqrt) / 2 / a;
    ret_vec_y = (-b - det_sqrt) / 2 / a;

    return ret_vec;
};

/* -1 for negative values of x, 1 for positive values, and 0 when x == 0
 */
float(float x) sign = {
    if (x < 0) {
        return -1;
    } else if (x > 0) {
        return 1;
    } else {
        return 0;
    }
};

/* Return the higher of two numbers
 */
float(float a, float b) max = {
    if (a > b) {
        return a;
    } else {
        return b;
    }
};

/* Return the lower of two numbers
 */
float(float a, float b) min = {
    if (a < b) {
        return a;
    } else {
        return b;
    }
};

/* Return the modulus of a over b.
 * Essentially, a sawtooth function of "a" with an amplitude and wavelength of
 * "b"
 */
float(float a, float b) mod = {
    return a - floor(a / b) * b;
};

/* Return a number min and max from in. If "in" is outside the range, change
 * "in" by a multiple of (max - min) such that it  fits the range. Lower bound
 * (min) is inclusive, upper bound (max) is exclusive.
 */
float(float in, float min, float max) wrap = {
    return mod(in - min, max - min) + min;
};

/* Takes an angular displacement vector, and returns an angular displacement
 * vector that represents the smallest change in angles (by magnitude) required
 * to rotate something into the same position the original vector would have
 * rotated the thing.
 *
 * i.e. don't rotate 361 degrees CW when we can rotate 1 degree CCW
 */
vector(vector in) normalize_delta_angles = {
    vector out;
    out_x = wrap(in_x, MIN_ANG, MAX_ANG);
    out_y = wrap(in_y, MIN_ANG, MAX_ANG);
    out_z = wrap(in_z, MIN_ANG, MAX_ANG);
    return out;
};
